object @orders

attributes :id, :number
node(:order_number) { |p| p.number }
node(:order_date){|p| p.updated_at }
child(:ship_address) do
		attributes :id, :user_name, :address1, :district, :city
	end
child(:time_delivery) do
	node(:time) { |p| p.delivery_time }
end

child :line_items => :line_items do
   extends "spree/api/line_items/show"
end