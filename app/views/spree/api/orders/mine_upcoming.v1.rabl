object @upcoming_line_items
attributes :product_id, :box_id, :quantity, :price
child(:product_item => :product) do
	attributes :id, :name
	child(:images => :images) { extends "spree/api/images/show" }
end
child(:box => :box) do
	attributes :id, :name
	node(:images) { "http://www.wbc.co.uk/13662_zoom-large-textured-hamper-box-red.jpg" }
end