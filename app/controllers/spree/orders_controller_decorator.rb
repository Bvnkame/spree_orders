Spree::Api::OrdersController.class_eval do
	include Spree::OrdersImporter
	require 'ostruct'
	before_action :authenticate_user
	before_action :find_order, except: [:create, :mine, :current, :index, :update, :mine_upcoming, :mine_past]
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


	def show
		authorize! :show, @order, order_token
		render "spree/api/orders/show", status: 201
	end

	def mine_past
		if current_api_user.persisted?
			@past_line_items = Spree::LineItem.select("spree_line_items.id, spree_line_items.quantity, spree_line_items.price, spree_line_items.delivery_date, spree_line_items.product_id,spree_line_items.box_id, spree_line_items.order_id, spree_orders.state, spree_orders.user_id")
										.joins(:order).where(:spree_orders => {:state => "complete", :user_id => current_api_user.id})
			p "abcd dkfjasdkfjasdkfj sadkfj askdf"
			p @past_line_items
			render "spree/api/orders/mine_past"
		else
			render "spree/api/errors/unauthorized", status: :unauthorized
		end
	end

	def mine_upcoming
		if current_api_user.persisted?
			@upcoming_line_items = Spree::LineItem.select("spree_line_items.id, spree_line_items.quantity, spree_line_items.price, spree_line_items.delivery_date, spree_line_items.product_id,spree_line_items.box_id, spree_line_items.order_id, spree_orders.state, spree_orders.user_id")
										.joins(:order).where(:spree_orders => {:state => "delivery", :user_id => current_api_user.id})
			
			render "spree/api/orders/mine_upcoming"
		else
			render "spree/api/errors/unauthorized", status: :unauthorized
		end
	end

end