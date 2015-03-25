module Spree
	Product.class_eval do 
		has_many :ingredients, through: :product_ingredients, :class_name => "Ingredient"
		has_many :product_ingredients, :class_name => "ProductIngredient", foreign_key: 'product_id'
		
		belongs_to :difficulty

		has_many :whatneeds, through: :product_whatneeds, :class_name => "Whatneed"
		has_many :product_whatneeds, :class_name => "ProductWhatneed", foreign_key: 'product_id'
		
		has_many :nutritions, through: :product_nutritions, :class_name => "Nutrition"
		has_many :product_nutritions, :class_name => "ProductNutrition", foreign_key: 'product_id'

		has_many :howtocooks, :class_name => "Howtocook"

		belongs_to :expert_opinion

		belongs_to :dish_type
	end
end