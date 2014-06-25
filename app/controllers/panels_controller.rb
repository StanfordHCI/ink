class PanelsController < ApplicationController

  def update
    @session_user = User.find(session[:user_id])
    @page = @session_user.page
    @panel = Panel.find(:panel_id) #pass this in as a hidden field?
  end

  def new
    @panel = Panel.new
  end

  def create
    @session_user = User.find(session[:user_id])
    @page = @session_user.page

    @panel = Panel.new
    @panel.page_id = @page.id
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
    if @panel.save
      redirect_to controller: 'pages', action: 'new', alert: "Panel saved successfully"
    else
      redirect_to controller: 'pages', action: 'new', alert: "Invalid panel. Please try again."
    end
  end

end
