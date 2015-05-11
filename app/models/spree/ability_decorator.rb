class AbilityDecorator
	include CanCan::Ability
	def initialize(user)
		if user.respond_to?(:has_spree_role?) && user.has_spree_role?('admin')
			can :manage, Spree::LineItem
		else
			can [:index],  Spree::LineItem if true
		end
	end
end

Spree::Ability.register_ability(AbilityDecorator)