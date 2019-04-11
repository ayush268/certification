module SessionsHelper

  # Logs in the given user
  def log_in(user)
    session[:user_id] = user.public_addr
  end

  # Returns the current logged-in user
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(public_addr: session[:user_id])
    end
  end

  def logged_in?
    !current_user.nil?
  end
  
  # Logs out the current user
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

end
