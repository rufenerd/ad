class UsersController < ApplicationController
  before_filter :require_login, :except => [:new, :create]
  
  def new
    @page_title = "Register"
    @user ||= User.new(params[:user])
  end

  def create
    @user ||= User.new
    create_or_update_user(params, 'You have successfully registered.', home_directives_path, new_user_path)
  end

  def show
    @user = User.find(params[:id])
    @page_title = "#{@user.name} (#{@user.username})"
  end

  def index
  end
  
  def edit
    @user = User.find(params[:id])
    render_404 unless @current_user == @user
    @page_title = "Edit Account Information"
  end

  def update
    @user = User.find(params[:id])
    render_404 unless @current_user == @user
    create_or_update_user(params, 'Your account info was successfully updated.', user_path(@user), user_path(@user))
  end

private

  def create_or_update_user(params, flash_msg, redirect_success, redirect_failure)
    @user.password = params[:password]

    if !params[:password].blank? && params[:password] == params[:password_confirmation] && @user.update_attributes(params[:user]) && @user.save
      do_log_in(@user)
      flash[:notice] = flash_msg
      redirect_to(params[:redirect] || redirect_success) 
    else
      flash[:notice] = @user.errors.to_a.join(", ")
      redirect_to redirect_failure
    end
  end

end

