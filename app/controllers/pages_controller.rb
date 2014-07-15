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
    #@options = Array.new
  end

  def create
    @session_user = User.find(session[:user_id])
    @page = Page.new(page_params)


    if @page.save
      @session_user.page = @page
      redirect_to @session_user, notice: "Successfully created page."
    else
      redirect_to action: 'new', alert: "Invalid form. Please try again."
    end
  end

  def edit
    @session_user = User.find(session[:user_id])
    @page = @session_user.page
    #@option = Array.new
  end

  def update
    @session_user = User.find(session[:user_id])
    @page = @session_user.page

=begin
    @option = Array.new
    if !((params[:page][:s_selectpanels_attributes]).nil?)
      for option in params[:page][:s_selectpanels_attributes][:options_attributes]
        @options.push(option[1][:option_name])
      end
    end

    if !((params[:page][:m_selectpanels_attributes]).nil?)
      for option in params[:page][:m_selectpanels_attributes][:options_attributes]
        @options.push(option[1][:option_name])
      end
    end
=end

    if @page.update(page_params)
      redirect_to @session_user, alert: "Successfully updated page."
    else
      redirect_to action: 'edit', alert: "Could not update. Please try again."
    end
  end

  private

  def page_params
    params.require(:page).permit(
      :user_id, :site_name, :description, :display_description,
      text_panels_attributes: [:id, :page_id, :panel_name, :display, :info, :_destroy],
      pictures_attributes: [:id, :page_id, :panel_name, :display, :description, :photo, :_destroy],
      s_selectpanels_attributes: [:id, :page_id, :panel_name, :display, :info, :_destroy,
        options_attributes: [:id, :selectpanel_id, :selectpanel_type, :option_title, :icon, :_destroy]],
        m_selectpanels_attributes: [:id, :page_id, :panel_name, :display, :info, :_destroy,
          options_attributes: [:id, :selectpanel_id, :selectpanel_type, :option_title, :icon, :_destroy]])
  end
end
