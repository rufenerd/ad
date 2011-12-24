# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :authenticate

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  def require_login
    not_allowed unless @current_user
  end

  # Load the current user from the session if they are logged in
  def authenticate
    begin
#      if cookies[:_ad_remember_me]
#        user_id, secret_key = cookies[:_ad_remember_me].split('_')
#        if secret_key == cookie_secret_key(user_id.to_i)
#          session[:user_id] = user_id.to_i
#        end
#      end
      @current_user = User.find(session[:user_id]) if session[:user_id]
    rescue
      session.delete(:user_id)
    end
  end


  # Set up the session and @current_user var
  def do_log_in(user)
    @current_user = user
    session[:user_id] = user.id
  end

  def not_allowed
    if @current_user.nil?
      session[:login_request_uri] = request.request_uri
      redirect_to login_authenticate_path
    end
  end

  protected

  def render_404  
    render :file => "#{RAILS_ROOT}/public/404.html", :status => '404 Not Found'
    true
  end
end
