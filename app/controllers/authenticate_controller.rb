class AuthenticateController < ApplicationController
  before_filter :require_login, :only => :logout

  def login
    unless request.get?
      user = User.authenticate(params[:username], params[:password])
      redirect_target = params[:redirect] 
      redirect_target = session[:login_request_uri] unless session[:login_request_uri] == "/"

      if user
        do_log_in(user) 
        session[:login_request_uri] = nil
        if params[:remember]
          cookies[:_ad_remember_me] = {:value => "#{user.id}_#{cookie_secret_key(user.id)}", :expires => 1.year.from_now}
        end
      else
        sleep(3)
        flash[:login_error] = true
      end
      
      redirect_target ||= root_path
    end

    if user && !request.get?
      redirect_to redirect_target
    else
      render :action => 'login_form'
    end
  end
  
  def logout
    session.delete :user_id
    cookies.delete :_ad_remember_me

    redirect_target = params[:redirect] || root_path

    respond_to do |format|
      format.json { render :json => {:success => true}.to_json }
      format.html { redirect_to redirect_target }
    end
  end
end

