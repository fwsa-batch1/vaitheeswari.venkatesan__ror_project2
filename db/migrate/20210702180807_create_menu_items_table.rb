class CreateMenuItemsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :menu_items_tables do |t|
      t.bigint "menu_category_id"
      t.string "name"
      t.text "description"
      t.decimal "price"
      t.integer "quantity_available"
      t.boolean "status"
      t.boolean "vegetarian"
      t.timestamps
    end
  end
end
