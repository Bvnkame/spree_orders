Spree::Api::OrdersController.class_eval do
	# before_action :authenticate_user, :except => [:index, :show]
	# def create
	# 	p current_api_user
	# 	p @current_user_roles
	# 	# authorize! :create, Order
	# 	order_user = if @current_user_roles.include?('admin') && order_params[:user_id]
	# 		Spree.user_class.find(order_params[:user_id])
	# 	else
	# 		current_api_user
	# 	end

	# 	import_params = if @current_user_roles.include?("admin")
	# 		params[:order].present? ? params[:order].permit! : {}
	# 	else
	# 		order_params
	# 	end

	# 	@order = Spree::Core::Importer::Order.import(order_user, import_params)
	# 	respond_with(@order, default_template: :show, status: 201)
	# end

end