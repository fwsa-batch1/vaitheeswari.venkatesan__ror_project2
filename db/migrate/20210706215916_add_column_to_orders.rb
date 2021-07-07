class AddColumnToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :shipping_address, :string
    add_column :orders, :billing_address, :string
    remove_column :menu_items, :quantity_available
    remove_column :menu_items, :vegetarian
  end
end
