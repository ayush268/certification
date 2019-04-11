class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :course_no, null: false
      t.string :course_session, null: false
      t.text :course_desc
      t.string :user_id

      t.timestamps
    end
  end
end
