class CreateUserCourseMappings < ActiveRecord::Migration[5.2]
  def change
    create_table :user_course_mappings do |t|
      t.string :user_id
      t.integer :course_id
      t.boolean :accepted
      t.boolean :passed

      t.timestamps
    end
  end
end
