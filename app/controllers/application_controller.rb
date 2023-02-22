class ApplicationController < ActionController::Base
    # Define current_user method to return the current user
    # def current_user
    #     @current_user ||= User.find_by(id: session[:user_id])
    # end

    # # Make current_user method available to all controllers and views
    # helper_method :current_user
    protect_from_forgery unless: -> { request.format.json? }
    # include PublicActivity::StoreController 
end
  