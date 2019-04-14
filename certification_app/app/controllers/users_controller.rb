class UsersController < ApplicationController

  def show
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

  def new
    if logged_in?
      redirect_to user_path(current_user[:public_addr])
    end
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


  private
    
    def user_params
      params.require(:user).permit(:name, :username, :email, :public_addr,
                                   :password, :password_confirmation)
    end

end
