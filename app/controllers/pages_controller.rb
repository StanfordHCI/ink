class PagesController < ApplicationController

  def index
    if session[:user_id]
      session_user = User.find(session[:user_id])
      @page = session_user.page
    end
  end

  def show
    @session_user = User.find(session[:user_id])
    @page = @session_user.page
  end

  def new
    @session_user = User.find(session[:user_id])
    @page = Page.new
  end

  def create
    @session_user = User.find(session[:user_id])
    @page = Page.new(page_params)
    if @page.save
      redirect_to @session_user, notice: "Successfully created page."
    else
      render :new
      #redirect_to action: 'new', alert: "Invalid form. Please try again."
    end
  end
  
  def edit
    @session_user = User.find(session[:user_id])
    @page = @session_user.page
  end
  
  def update
    @session_user = User.find(session[:user_id])
    @page = @session_user.page
    if @page.update(page_params)
      redirect_to @session_user, alert: "Successfully updated page."
    else
      render :edit
      #redirect_to action: 'edit', alert: "Could not update. Please try again."
    end
  end

=begin
  def new
    @session_user = User.find(session[:user_id])
    if ((@session_user.page).nil?)
      @page = Page.new
    else
      @page = @session_user.page
    end
    @page_panels = @page.panels
  end

  def create
    @session_user = User.find(session[:user_id])
    if ((@session_user.page).nil?) #this if may not be necessary
      @page = Page.new(page_params)
    else
      @page = @session_user.page #never gets here if auto calls update
    end
    @page.user_id = @session_user.id
    @page.site_name = params[:page][:site_name]
    @page.description = params[:page][:description]

    create_panel(params[:page][:panels_attributes], @page)

    if @page.save
      redirect_to @session_user
    else
      redirect_to action: 'new', alert: "Invalid form. Please try again."
    end
  end

  def update
    @session_user = User.find(session[:user_id])
    @page = @session_user.page
    @page.user_id = @session_user.id
    @page.site_name = params[:page][:site_name]
    @page.description = params[:page][:description]

    create_panel(params[:page][:panels_attributes], @page)

    if @page.update_attributes(params.require(:page).permit(:site_name, :description, panels_attributes: [:panel_name, :display, :panel_type, :background_file]))
      redirect_to @session_user
    else
      redirect_to action: 'new', alert: "Could not update. Please try again."
    end
  end
=end
  private
  
  def page_params
    params.require(:page).permit(
      :user_id, :site_name, :description,
      text_panel_attributes: [:id, :page_id, :panel_name, :display, :info, :_destroy],
      picture_attributes: [:id, :page_id, :panel_name, :display, :description, :photo, :_destroy],
      s_selectpanel_attributes: [:id, :page_id, :panel_name, :display, :info, :_destroy,
        option_attributes: [:id, :s_selectpanel_id, :option_name, :_destroy]],
      m_selectpanel_attributes: [:id, :page_id, :panel_name, :display, :info, :_destroy,
        option_attributes: [:id, :m_selectpanel_id, :option_name, :_destroy]])
  end

=begin
  def create_panel(attributes, cur_page)
    if !(attributes.nil?)
      for panel in attributes
        new_panel = cur_page.panels.build #pass in (panel[1])?
        new_panel.page_id = cur_page.id
        new_panel.panel_name = panel[1][:panel_name]
        new_panel.display = panel[1][:display]
        new_panel.panel_type = panel[1][:panel_type]

        uploaded = panel[1][:background]
        if !(uploaded.nil?)
          File.open(Rails.root.join('app','assets','images', uploaded.original_filename), 'wb') do |file|
            file.write(uploaded.read)
          end
          new_panel.background_file = panel[1][:background].original_filename
        end
        new_panel.save #add validation here
      end
    end
  end
=end
end
