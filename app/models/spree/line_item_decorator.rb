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
      	self.price = 100
        # self.price    = variant.price_in(currency).amount +
         #                 variant.price_modifier_amount_in(currency, opts)
       else
         self.price = 100
        # self.price    = variant.price +
       #                 variant.price_modifier_amount(opts)
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