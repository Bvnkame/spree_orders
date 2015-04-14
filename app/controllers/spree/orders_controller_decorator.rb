Spree::Api::OrdersController.class_eval do
	include Spree::OrdersImporter
	require 'ostruct'
	before_action :authenticate_user
	before_action :find_order, except: [:create, :mine, :current, :index, :update, :mine_upcoming, :mine_orders]
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
		if @order.update(order_update_params[:order])
			@address = @order.address
			if @address.update(order_update_params[:address])
				@status = [ { "messages" => "Update Address Successful"}]
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


	private 
	def order_params
		params.require(:order).permit(:time_delivery_id)
	end
	def order_update_params
		params.require(:order).permit(:time_delivery_id)
		params.require(:address).permit(:user_name, :address1, :phone, :city, :district)
	end

end