Spree::Order.class_eval do 
	
	def find_line_item_by_product(variant, options = {})
		line_items.detect { |line_item|
			line_item.product_id == variant.id 
		}
	end
	def find_line_item_by_box(variant, options = {})
		line_items.detect { |line_item|
			line_item.box_id == variant.id
		}
	end

end