class CreateAdmins < ActiveRecord::Migration[5.2]
  def change
    create_table :admins, id: false do |t|
      t.string :username
      t.string :hashed_id, null: false

      t.timestamps
    end

    add_index :admins, :hashed_id, unique: true
  end
end
