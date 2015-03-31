Spree::LineItem.class_eval do 
	belongs_to :product_item, class_name: "Spree::Product", foreign_key: "product_id"

	belongs_to :box, class_name: "Bm::Box"

 clear_validators!

 def options=(options={})
   return unless options.present?


      opts = options.dup # we will be deleting from the hash, so leave the caller's copy intact

      currency = opts.delete(:currency) || order.try(:currency)

      if currency
      	self.currency = currency
        if product_item
          self.price    = product_item.dish_price
        else 
          box_price = 0
          box.products.each do |product|
            box_price += product.dish_price
          end
          self.price = box_price
        end
      else
        if product_item
         self.price    = product_item.dish_price
        else 
          box_price = 0
          box.products.each do |product|
            box_price += product.dish_price
          end
          self.price = box_price
        end
      end
      self.assign_attributes opts
    end

    private 
    def update_inventory
	    	# if (changed? || target_shipment.present?) && self.order.has_checkout_step?("delivery")
	     	#      Spree::OrderInventory.new(self.order, self).verify(target_shipment)
				#    end
      end
      def update_adjustments
  	    	# if quantity_changed?
  	     	#      update_tax_charge # Called to ensure pre_tax_amount is updated.
  	     	#      recalculate_adjustments
  	     	#    end
        end
      end