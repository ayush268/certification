class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: false do |t|
      t.string :name
      t.string :username
      t.string :public_addr, null: false
      t.string :password_digest

      t.timestamps
    end

    add_index :users, :public_addr, unique: true
  end
end
