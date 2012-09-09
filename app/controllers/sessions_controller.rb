class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.authenticate(params[:session][:username], params[:session][:password])
    
    if user.nil?
      flash[:error] = "Wrong username/password"
      render 'new'
    else
      sign_in user
      redirect_to '/'
    end
  end
  
  def destroy
    sign_out
    redirect_to '/'
  end

end
