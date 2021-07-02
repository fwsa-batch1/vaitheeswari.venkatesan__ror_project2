class CreateCartsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :carts_tables do |t|
      t.bigint :user_id
      t.decimal :total_price
      t.timestamps
    end
  end
end
