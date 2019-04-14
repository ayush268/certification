class Admin < ApplicationRecord
  self.primary_key = 'hashed_id'
  
  def courses_accepted
  end

end
