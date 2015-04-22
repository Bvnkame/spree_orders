Spree::Api::OrdersController.class_eval do
	include Spree::OrdersImporter
	require 'ostruct'
	before_action :authenticate_user
	before_action :find_order, except: [:create, :mine, :current, :index, :update, :mine_upcoming, :mine_past, :place_order ]
	def create
		@order = find_cart_order
		unless @order
			order_user = if @current_user_roles.include?('admin') && order_params[:user_id]
				Spree.user_class.find(order_params[:user_id])
			else
				current_api_user
			end

			import_params = if @current_user_roles.include?("admin")
				params[:order].present? ? params[:order].permit! : {}
			else
				order_params
			end

			@order = Spree::Core::Importer::Order.import(order_user, import_params)
		end
		respond_with(@order, default_template: :show_number, status: 201)
	end

	def update
		find_order(true)
		authorize! :update, @order, order_token
		if @order.update(order_params)
			@address = @order.ship_address
			if @address.update(address_params)
				@status = [ { "messages" => "Update Address - Time Successful"}]
				render "spree/api/logger/log", status: 200
			end
		end
	end

	def show
		authorize! :show, @order, order_token
		render "spree/api/orders/show", status: 201
	end

	def empty
		authorize! :update, @order, order_token
		@order.empty!
		@status = [{ "messages" => "Empty All Line Item in"}]
		render "spree/api/logger/log", status: 204
	end

	def mine_past
		if current_api_user.persisted?
			@past_orders = Spree::Order.where(:user_id => current_api_user.id).where.not(:state => "cart")
			render "spree/api/orders/mine_past"
		else
			render "spree/api/errors/unauthorized", status: :unauthorized
		end
	end

	def mine_upcoming
		if current_api_user.persisted?
			@upcoming_orders = Spree::Order.where(:user_id => current_api_user.id).where.not(:state => "cart")
			render "spree/api/orders/mine_upcoming"
		else
			render "spree/api/errors/unauthorized", status: :unauthorized
		end
	end

	def place_order
		@order = Spree::Order.find_by!(number: params[:order_number])
		authorize! :update, @order

		@user = current_api_user

		amount = @order.total_price

		@payment = Spree::Payment.find_by!(order_id: @order.id)
		if @payment.payment_type == "Cash"
			@order.update(state: "delivery")
			@order.line_items.update_all(status: "delivery")

			@payment.update(amount: amount)
			@status = [{ "messages" => "Place Order Successful!"}]
			render "spree/api/logger/log", status: 200

		elsif @payment.payment_type == "PrepaidCard"

			@user_account =  @user.user_account
			if amount <= @user_account.account
				up_account = @user_account.account - @order.total_price
				@user_account.update(account: up_account)

				@order.update(state: "delivery")
				@order.line_items.update_all(status: "delivery")

				@payment.update(amount: amount, is_pay: true)
				@status = [{ "messages" => "Place Order Successful!"}]
				render "spree/api/logger/log", status: 200
			else
				@status = [{ "messages" => "Your Money in Prepaid Card is not enough!"}]
				render "spree/api/logger/log", status: 406
			end
			
		end

	end


	private 
	def order_params
		params.require(:order).permit(:time_delivery_id)
	end
	def address_params
		params.require(:address).permit(:user_name, :address1, :phone, :city, :district)
	end

end