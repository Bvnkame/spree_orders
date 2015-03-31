Spree::Api::OrdersController.class_eval do
	include Spree::OrdersImporter
	before_action :authenticate_user
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
end