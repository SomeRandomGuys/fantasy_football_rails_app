module SessionsHelper
  def sign_in(user)
    cookies.permanent.signed[:auth_token] = [user.id, user.username]
    cookies.permanent.signed[:user_id] = user.id
    self.current_user = user
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    return nil if cookies.signed[:auth_token].nil?
    @current_user ||= User.find(cookies.signed[:auth_token][0])
  end
  
  def current_user_id
    cookies.signed[:user_id]
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    cookies.delete([:auth_token])
    current_user = nil
  end
end
