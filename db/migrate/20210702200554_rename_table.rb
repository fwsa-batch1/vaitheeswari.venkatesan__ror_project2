class RenameTable < ActiveRecord::Migration[6.1]
  def change
    rename_table :menu_categories_tables, :menu_categories
    rename_table :menu_items_tables, :menu_items
    rename_table :carts_tables, :carts
    rename_table :orders_tables, :orders
    rename_table :order_items_tables, :order_items
    rename_table :users_tables, :users
  end
end
