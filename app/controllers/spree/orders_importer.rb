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
				@order = Spree::Order.new_order(user)
			end
			p "order list"
			p @order
			p "order fisrs"
			@order
		end
	end
end