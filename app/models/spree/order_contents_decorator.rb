Spree::OrderContents.class_eval do 
	def adddish(variant, quantity = 1, options = {})
		line_item = add_dish_to_line_item(variant, quantity, options)
	end

	def addbox(variant, quantity = 1, options = {})
		line_item = add_box_to_line_item(variant, quantity, options)
	end

	private 
	def add_dish_to_line_item(variant, quantity, options = {})
		opts = { currency: order.currency }.merge ActionController::Parameters.new(options).
		permit(Spree::PermittedAttributes.line_item_attributes)
		line_item = order.line_items.new(quantity: quantity,
			product_item: variant,
			options: opts)
		line_item.save
		line_item

	end 

	def add_box_to_line_item(variant, quantity, options = {})
		opts = { currency: order.currency }.merge ActionController::Parameters.new(options).
		permit(Spree::PermittedAttributes.line_item_attributes)
		line_item = order.line_items.new(quantity: quantity,
			box: variant,
			options: opts)
		line_item.save!
		line_item
	end 


	def grab_line_item_by_product(variant, raise_error = false, options = {})
		line_item = order.find_line_item_by_product(variant, options)
		if !line_item.present? && raise_error
			raise ActiveRecord::RecordNotFound, "Line item not found for product"
		end

		line_item
	end

	def grab_line_item_by_box(variant, raise_error = false, options = {})
		line_item = order.find_line_item_by_box(variant, options)
		p line_item
		if !line_item.present? && raise_error
			raise ActiveRecord::RecordNotFound, "Line item not found for box"
		end
		line_item
	end
end