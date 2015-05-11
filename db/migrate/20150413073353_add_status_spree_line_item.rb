class AddStatusSpreeLineItem < ActiveRecord::Migration
  def change
  	add_column :spree_line_items, :status, :string, :default => "cart"
  end
end
