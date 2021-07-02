class CreateMenuCategoriesTable < ActiveRecord::Migration[6.1]
  def change
    create_table :menu_categories_tables do |t|
      t.string "menu_category_name"
      t.boolean "status"
      t.timestamps
    end
  end
end
