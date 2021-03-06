object @upcoming_orders

attributes :id
node(:order_number) { |p| p.number }
node(:order_date){|p| p.completed_at }
child(:ship_address) do
		attributes :id, :user_name, :address1, :district, :city
	end
child(:time_delivery) do
	node(:time) { |p| p.delivery_time }
end

child :find_upcoming_order=> :line_items do
	extends "spree/api/line_items/show", :if => lambda{|p| p.status === "delivery"}
end