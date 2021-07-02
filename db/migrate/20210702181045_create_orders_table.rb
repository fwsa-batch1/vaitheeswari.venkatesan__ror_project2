class CreateOrdersTable < ActiveRecord::Migration[6.1]
  def change
    create_table :orders_tables do |t|
      t.bigint "user_id"
      t.decimal "total_price"
      t.boolean "paid"
      t.boolean "pending"
      t.string "delivered_at"
      t.date "order_placed"

      t.timestamps
    end
  end
end
