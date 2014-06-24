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
    @page.panels.build
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
    #add_panel(@page)

    if @page.save
      redirect_to @session_user
    else
      redirect_to action: 'new', alert: "Invalid form. Please try again."
    end
  end

  def add_panel(page)
    @panel = Panel.new
    @panel.page_id = page.id
    @panel.panel_name = params[:panel_name]
    @panel.display = params[:display]
    @panel.panel_type = params[:panel_type]
    
    uploaded = params[:background]
    if !(uploaded.nil?)
      File.open(Rails.root.join('app','assets','images', uploaded.original_filename), 'wb') do |file|
        file.write(uploaded.read)
      end
      @panel.background_file = params[:background].original_filename
    end
  end
end
