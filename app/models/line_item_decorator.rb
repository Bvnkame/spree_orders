module Spree
	LineItem.class_eval do 
		belongs_to :product
		
		belongs_to :box
	end
end