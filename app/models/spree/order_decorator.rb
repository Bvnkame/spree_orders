Spree::Order.class_eval do 

	def total_price
		total = 0
		self.line_items.each do |line_item|
			total += line_item.price.to_f * line_item.quantity.to_f
		end
		total
	end

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

	def find_past_order
		self.line_items.where(:status => "complete") 
	end
	
	def find_upcoming_order
		self.line_items.where(:status => "delivery") 
	end

end