class UsersController < ApplicationController

  def show
    @user = User.find(params[:public_addr])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to Certification!"
      redirect_to @user
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
