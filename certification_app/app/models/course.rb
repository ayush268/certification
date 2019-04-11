class Course < ApplicationRecord
  belongs_to :user
  has_many :user_course_mappings
  has_many :students_applied, class_name: 'User', through: :user_course_mappings, :source => :user
end
