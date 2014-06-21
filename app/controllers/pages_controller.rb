class PagesController < ApplicationController

  def index
  end

  def new
    @session_user = User.find(session[:user_id])
  end

  def create
    @session_user = User.find(session[:user_id])
    @page = Page.new
    @page.user_id = @session_user.id
    @page.site_name = params[:user][:site_name]
    @page.description = params[:user][:description]
    @page.panel_name = params[:user][:panel_name]
    @page.display_panel_name = params[:user][:display]
    @page.panel_type = params[:user][:panel_type]

    uploaded = params[:user][:background]
    File.open(Rails.root.join('app','assets','images', uploaded.original_filename), 'wb') do |file|
      file.write(uploaded.read)
    end
    @page.background_file = params[:user][:background].original_filename
   
    @page.save
  end
end
