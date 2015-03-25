object @line_item
cache [I18n.locale, root_object]
attributes *line_item_attributes
node(:single_display_amount) { |li| li.single_display_amount.to_s }
node(:display_amount) { |li| li.display_amount.to_s }
node(:total) { |li| li.total }

child :product_item => :product do
	extends "spree/api/products/small_show"
end

child :box => :box do
	extends "bm/show"
end
child :adjustments => :adjustments do
  extends "spree/api/adjustments/show"
end
