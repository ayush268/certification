class Course < ApplicationRecord
  belongs_to :user
  has_many :user_course_mappings
  has_many :students_applied, class_name: 'User', through: :user_course_mappings, :source => :user

  def get_course_info
    content = course_no + ", " + course_session + " taken by: " + user.name + "(" + user.public_addr + ")" + "\n" + course_desc
  end

  def accepted_users
  end

  def private_key
  end

end
