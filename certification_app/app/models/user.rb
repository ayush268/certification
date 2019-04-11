class User < ApplicationRecord
  self.primary_key = 'public_addr'
  has_many :courses
  has_many :user_course_mappings
  has_many :courses_taken, class_name: 'Course', through: :user_course_mappings, :source => :course
end
