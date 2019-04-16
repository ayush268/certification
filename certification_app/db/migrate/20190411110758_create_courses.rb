class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :course_no, null: false
      t.string :course_session, null: false
      t.text :course_desc
      t.string :user_id
      t.boolean :accepted
      t.datetime :accepted_time
      t.string :contract_addr

      t.timestamps
    end
  end
end
