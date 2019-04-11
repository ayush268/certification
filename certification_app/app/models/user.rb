class User < ApplicationRecord
  self.primary_key = 'public_addr'

  validates :name, presence: true, length: { maximum: 50 }
  validates :username, presence: true, length: { maximum: 30 }, uniqueness: true
  validates :public_addr, presence: true, length: {is: 40}, uniqueness: true

  has_many :courses
  has_many :user_course_mappings
  has_many :courses_taken, class_name: 'Course', through: :user_course_mappings, :source => :course

  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }
end
