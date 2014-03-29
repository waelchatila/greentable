class ApplicationController < ActionController::Base
  protect_from_forgery

  def home
    render 'application/home'
  end
end
