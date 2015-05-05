object @user

node(:cart_number) { @order.number }

child :user_account => :user do
	attributes :account, :currency
end