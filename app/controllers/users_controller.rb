class UsersController < ApplicationController
  
  def new
    @user = User.new
  end
  
  def create
    user = User.new(params[:user])
    if user.save
      sign_in user
      redirect_to root_path
    else
      flash[:error] = "Error creating user"
      redirect_to "/signup"
    end
  end
  
end
