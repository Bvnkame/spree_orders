class AddDateDeliverytoSpreeOrder < ActiveRecord::Migration
  def change
  	add_column :spree_line_items, :delivery_date, :datetime
  end
end
