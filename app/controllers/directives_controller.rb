class DirectivesController < ApplicationController
  before_filter :require_login

  def index
    @page_title = "Directives"
    
    if params["tag_list"]
      @tags = params["tag_list"].reject{|t| t[1] == "0"}.map(&:first)
      @match_all = params["match_all"] == "1"
      @directives = Directive.find_tagged_with(@tags, :match_all => @match_all)
    else
      @directives = Directive.all
    end    
  end

  def home
    @page_title = "Home"
  end

  def show
    @directive = Directive.find(params[:id])
    @page_title = @directive.name
  end

  def new
    @page_title = "Submit Directive"
    @directive = Directive.new
  end
  
  def create
    @directive ||= Directive.new
    update_or_create_directive(params, "Directive was successfully created.", new_directive_path)
  end

  def edit
    @directive = Directive.find(params[:id])
    @page_title = "Edit Submission: #{@directive.name}"
  end

  def update
    @directive = Directive.find(params[:id])
    update_or_create_directive(params, "Directive was successfully updated.", edit_directive_path(@directive))
  end

  def destroy
    @directive = Directive.find(params[:id])
    @directive.destroy
    flash[:notice] = 'Directive was successfully created.'
    redirect_to directives_path
  end

  def star
    switch("star")
  end

  def unstar
    unswitch("star")
  end

  def flag
    switch("flag")
  end

  def unflag
    unswitch("flag")
  end

  def switch(kind)
    @directive = Directive.find(params[:id])
    DirectiveUser.create(:user => @current_user, :directive => @directive, :kind => kind)
    render :text => "OK"
  end

  def unswitch(kind)
    @directive = Directive.find(params[:id])
    du = DirectiveUser.find(:first, :conditions => {:user_id => @current_user.id, :directive_id => @directive.id, :kind => kind})
    du.destroy if du
    render :text => "OK"
  end

  def admin
    render_404 unless @current_user.admin?
    @flags = DirectiveUser.find_all_by_kind("flag")
    @stars = DirectiveUser.find_all_by_kind("star")
  end

private
  def update_or_create_directive(params, flash_msg, redirect_failed)
    tags = params["directive"].delete("tag_list")
    @directive.tag_list = tags.select{|k,v| v == "1"}.map(&:first)
    if @directive.update_attributes(params[:directive]) && @directive.save
      DirectiveUser.create(:user => @current_user, :directive => @directive, :kind => "submission")
      flash[:notice] = flash_msg
      redirect_to(params[:redirect] || directive_path(@directive))
    else
      redirect_to redirect_failed
    end
  end
end
