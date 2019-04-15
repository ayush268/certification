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
    
    keys = get_keys
    @user[:public_addr] = keys[:public_addr]
    if @user.save
      
      send_data keys.to_json,
        :type => 'text/json; charset=UTF-8;',
        :disposition => "attachment; filename=keep_it_safe.json"

      log_in @user
      flash[:success] = "Welcome to Certification!"
      #redirect_to user_path(@user[:public_addr])
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
                                   :password, :password_confirmation)
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
