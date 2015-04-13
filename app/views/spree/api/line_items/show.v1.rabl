object @line_item
cache [I18n.locale, root_object]
attributes :id, :product_id, :box_id, :quantity, :delivery_date, :price, :status

child :product_item => :product do
		attributes :id, :name
		child(:images => :images) { extends "spree/api/images/show" }
end

child :box => :box do
	attributes :id, :name
	node(:images) { "http://www.wbc.co.uk/13662_zoom-large-textured-hamper-box-red.jpg" }
	child(:products => :products) { attributes :id}
end
