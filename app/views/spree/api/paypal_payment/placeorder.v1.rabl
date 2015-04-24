object @order

node(:cart_number) { |p| p.number }

object @user

child :user_account => :user do
	attributes :account, currency
end