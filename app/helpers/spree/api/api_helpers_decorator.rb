Spree::Api::ApiHelpers.class_eval do 

	def line_item_attributes
		[:id, :product_id, :box_id, :quantity]
	end

end
