class AdminController < ApplicationController

  def all
    if not Admin.where(hashed_id: params[:hashed_id]).exists?
      redirect_to root_url
    end
    @admin = Admin.find(params[:hashed_id])
    @courses = Course.all.select{ |course| not course.accepted }
  end

  def submit
    courses_accepted = params[:courses_accepted][:id]
    courses_accepted.select!{ |v| v.to_i != 0 }
  end

end
