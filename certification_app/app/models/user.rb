class User < ApplicationRecord
  self.primary_key = 'public_addr'

  validates :name, presence: true, length: { maximum: 50 }
  validates :username, presence: true, length: { maximum: 30 }, uniqueness: true
  validates :email, presence: true, length: { maximum: 100 }, uniqueness: true
  validates :public_addr, presence: true, length: {is: 40}, uniqueness: true

  has_many :courses
  has_many :user_course_mappings
  has_many :courses_taken, class_name: 'Course', through: :user_course_mappings, :source => :course

  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }

  # Returns the hash digest of the given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
