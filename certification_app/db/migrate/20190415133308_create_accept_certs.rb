class CreateAcceptCerts < ActiveRecord::Migration[5.2]
  def change
    create_table :accept_certs do |t|
      t.string :user_id
      t.integer :course_id
      t.string :desc

      t.timestamps
    end
  end
end
