class UserCourseMapping < ApplicationRecord
  belongs_to :user
  belongs_to :course

  def get_user_info
    return "Name: " + user.name + '; Username: ' + user.username + ';'
  end

end
