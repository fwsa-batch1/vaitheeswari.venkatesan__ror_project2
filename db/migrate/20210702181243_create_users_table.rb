class CreateUsersTable < ActiveRecord::Migration[6.1]
  def change
    create_table :users_tables do |t|
      t.string "first_name"
      t.string "last_name"
      t.string "role"
      t.string "email"
      t.string "password_digest"
      t.string "address"
      t.string "phone_number"
      t.timestamps
    end
  end
end
