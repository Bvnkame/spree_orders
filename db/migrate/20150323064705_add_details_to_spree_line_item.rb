class AddDetailsToSpreeLineItem < ActiveRecord::Migration
  def change
  	add_column :spree_line_items, :product_id, :integer
  	add_column :spree_line_items, :box_id, :integer
  end
end
