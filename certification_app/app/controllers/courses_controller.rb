class CoursesController < ApplicationController

  def all
    if not logged_in?
      redirect_to login_path
    else
      courses = Course.all.select{ |course| course.accepted }
      @courses = []
      if courses.size != 0
        @courses = courses.all.map do |course|
          {
            id: course.id,
            no: course.course_no,
            session: course.course_session,
            desc: course.course_desc,
            status: course_status(course),
            inst: course.user
          }
        end
      end
    end
  end

  def new
    if not logged_in?
      redirect_to login_path
    end
    @course = Course.new
  end

  def create
    if not logged_in?
      redirect_to login_path
    end
    user_id = current_user[:public_addr]
    final_params = {accepted: false, user_id: user_id}
    final_params.reverse_merge!(course_params)
    @course = Course.new(final_params)
    if @course.save
      flash[:success] = "Your course request has gone for approval!"
      redirect_to user_path(user_id)
    else
      render 'new'
    end
  end

  def show
    if not logged_in?
      redirect_to login_path
    else

    end
  end

  private

    def course_params
      params.require(:course).permit(:course_no, :course_session, :course_desc)
    end
end
