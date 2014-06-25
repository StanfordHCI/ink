class PagesController < ApplicationController

  def index
  end

  def new
    @session_user = User.find(session[:user_id])
    if ((@session_user.page).nil?)
      @page = Page.new
    else
      @page = @session_user.page
    end
    panel = @page.panels.build
    panel.save #this is necessary for panel to save
  end

  def create
    @session_user = User.find(session[:user_id])
    if ((@session_user.page).nil?)
      @page = Page.new
    else
      @page = @session_user.page
    end
    @page.user_id = @session_user.id
    @page.site_name = params[:site_name]
    @page.description = params[:description]

    if @page.save
      redirect_to @session_user
    else
      redirect_to action: 'new', alert: "Invalid form. Please try again."
    end
  end

end
