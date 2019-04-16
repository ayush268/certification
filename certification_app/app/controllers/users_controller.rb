class UsersController < ApplicationController

  def show
    if not logged_in?
      redirect_to login_path
    else
      if current_user[:public_addr] == params[:public_addr]
        @user = User.find(params[:public_addr])
        courses_offered = @user.courses.select{ |c| c.accepted }.map do |course|
          {
            id: course.id,
            no: course.course_no,
            session: course.course_session,
            desc: course.course_desc,
            status: course_status(course),
            inst: course.user
          }
        end
        course_mappings = @user.user_course_mappings
        courses_taken = course_mappings.select{ |m| m.course.accepted }.map do |m|
          {
            id: m.course.id,
            no: m.course.course_no,
            session: m.course.course_session,
            desc: m.course.course_desc,
            status: course_status(m.course),
            inst: m.course.user
          }
        end
        @courses = courses_offered + courses_taken
      else
        redirect_to user_path(current_user[:public_addr])
      end
    end
  end

  def new
    if logged_in?
      redirect_to user_path(current_user[:public_addr])
    end
    puts(params)
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      log_in @user
      flash[:success] = "Welcome to Certification!"
      redirect_to user_path(@user[:public_addr])
    else
      render 'new'
    end
  end

  def edit
    if not logged_in?
      redirect_to login_path
    else
      if current_user[:public_addr] == params[:public_addr]
        @user = User.find(params[:public_addr])
      else
        redirect_to user_path(current_user[:public_addr])
      end
    end
  end

  def update
    if not logged_in?
      redirect_to login_path
    end
    @user = current_user
    if @user.update(update_user_params)
      flash[:success] = "Profile Updated Successfully!"
      redirect_to user_path(@user[:public_addr])
    else
      render 'edit'
    end
  end

  private
    
    def user_params
      params.require(:user).permit(:name, :username, :email,
                                   :password, :password_confirmation,
                                   :public_key, :public_addr)
    end

    def update_user_params
      params.permit(:name, :username, :email)
    end

    def get_keys
      token = get_token
      response = HTTParty.post("https://api.blockcypher.com/v1/eth/main/addrs", body: { token: token })
      return_val = {}
      return_val[:public_addr] = response["address"]
      return_val[:public_key] = response["public"]
      return_val[:private_key] = response["private"]
      return_val
    end

end
