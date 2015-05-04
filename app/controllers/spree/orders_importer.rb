module Spree
	module OrdersImporter

		def find_cart_order
			@order = current_api_user ? current_api_user.orders.where(state: "cart").order(:created_at).last : nil
		end

		def find_cart_order_login(user)
			p "cart in login method"
			p user
			@order = user ? user.orders.where(state: "cart").order(:created_at).last : nil
		end
		def create_order(user)
			unless @order
				order_user = user

				import_params = {}
				@order = Spree::Core::Importer::Order.import(order_user, import_params)
			end
			p @order
			@order
		end
	end
end