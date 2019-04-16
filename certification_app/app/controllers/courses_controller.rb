class CoursesController < ApplicationController

  def all
    if not logged_in?
      redirect_to login_path
    else
      courses = Course.all.select{ |course| course.accepted }
      @courses = []
      if courses.size != 0
        @courses = courses.map do |course|
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
      #TODO Complete this function
      @course = Course.find(params[:id])
      if not @course.accepted
        redirect_to courses_path
      end

      case inst_or_student_or_else?(@course)
        when 1
          @students = @course.user_course_mappings.map do |m|
            {
              name: m.user.name,
              username: m.user.username,
              addr: m.user.public_addr,
              status: m.accepted,
              passed: m.passed,
              email: m.user.email
            }
          @mappings = @course.user_course_mappings.select{ |x| not x.accepted }
          @accepted_mappings = @course.user_course_mappings.select{ |x| x.accepted }
          end
          render 'inst_page'
        when 2
          #TODO
        when 3
          render 'rejected_page'
        else
          render 'other_people_page'
      end

    end
  end

  def update
    if params[:commit] == "Register"
      if register_student(params[:id])
        flash[:success] = "Your course request has been sent to the instructor for approval!"
        redirect_to user_path(current_user[:public_addr])
      else
        redirect_to course_path(params[:id])
      end
    end
    if params[:commit] == "Approve Requests"
      accepted_mappings = params[:accepted_users][:id]
      accepted_mappings.select!{ |v| v.to_i != 0 }

      cert_hash_list = []
      accepted_mappings.each do |id|
        m = UserCourseMapping.find(id)
        cert_hash_list.append(approve_student(m))
        m.update(accepted: true)
      end
      redirect_to user_path(current_user[:public_addr])
    end
    if params[:commit] == "Submit Grades"
      passed_mappings = params[:passed_users][:id]
      passed_mappings.select!{ |v| v.to_i != 0 }

      passed_mappings.each do |id|
        m = UserCourseMapping.find(id)
        m.update(passed: true)
      end
      redirect_to user_path(current_user[:public_addr])
    end
  end

  private

    def course_params
      params.require(:course).permit(:course_no, :course_session, :course_desc)
    end

    def inst_or_student_or_else?(course)
      if current_user[:public_addr] == course.user[:public_addr]
        return 1
      end
      users = course.user_course_mappings
      users_accepted = users.select{ |m| m.accepted }.map{ |x| x.user.public_addr }
      users_rejected = users.select{ |m| not m.accepted }.map{ |x| x.user.public_addr }
      if users_accepted.include? current_user[:public_addr]
        return 2
      elsif users_rejected.include? current_user[:public_addr]
        return 3
      end
      return 4
    end

    def register_student(course_id)
      mapping = UserCourseMapping.new(user_id: current_user[:public_addr], course_id: course_id, accepted: false, passed: false)
      if mapping.save
        return true
      else
        return false
      end
    end
end
