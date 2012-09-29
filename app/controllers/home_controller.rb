class HomeController < ApplicationController
  
  #layout 'standard'
  
  def index
    #render :action => "index"
    #signin_required = true
    @title = 'home'
  end
end
