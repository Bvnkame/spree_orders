object @upcoming_line_items

attributes :id, :product_id, :box_id, :quantity, :price, :delivery_date

child(:product_item => :product) do
	attributes :id, :name
	child(:images => :images) { extends "spree/api/images/show" }
end

child(:box => :box) do
	attributes :id, :name
	node(:images) { "http://www.wbc.co.uk/13662_zoom-large-textured-hamper-box-red.jpg" }
end

child( :order) do
	node(:cart_number) {|p| p.number }
	child(:ship_address) do
		attributes :id, :user_name, :address1, :district, :city
	end
	child(:time_delivery) do
		node(:time) { |p| p.delivery_time }
	end
end

