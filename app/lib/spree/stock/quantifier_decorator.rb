Spree::Stock::Quantifier.class_eval do
	 def total_on_hand
        # if @variant.should_track_inventory?
        #   stock_items.sum(:count_on_hand)
        # else
        #   Float::INFINITY
        # end
      end
      def can_supply?(required)
      	return true
        # total_on_hand >= required || backorderable?
      end
end