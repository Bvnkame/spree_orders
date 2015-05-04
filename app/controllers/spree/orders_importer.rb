module Spree
	module OrdersImporter

		def find_cart_order
			@order = current_api_user ? current_api_user.orders.where(state: "cart").order(:created_at).last : nil
		end

		def find_cart_order_login(user)
			@order = user ? user.orders.where(state: "cart").order(:created_at).last : nil
		end
		
	end
end