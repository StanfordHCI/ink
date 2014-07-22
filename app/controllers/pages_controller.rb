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
    @options = Array.new
  end

  def create
    @session_user = User.find(session[:user_id])
    @page = Page.new(page_params)
    if !((params[:page][:pictures_attributes]).nil?)
      for picture_attribute in params[:page][:pictures_attributes]
        uploaded = picture_attribute[1][:photo]
        if !(uploaded.nil?)
          File.open(Rails.root.join('app', 'assets', 'images', uploaded.original_filename), 'wb') do |file|
            file.write(uploaded.read)
          end
          picture_panel = Picture.find_by_id(picture_attribute[1][:id])
          if !(picture_panel.nil?)
            picture_panel.background_file = uploaded.original_filename
          end
        end
      end
    end
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
    for panel in @page.text_panels
      for tag in panel.tags
        tag.destroy
      end
    end

    for panel in @page.pictures
      for tag in panel.tags
        tag.destroy
      end
    end

    @options = Array.new
    for panel in @page.s_selectpanels
      for tag in panel.tags
        tag.destroy
      end
      for option in panel.options
        @options.push(option.option_title)
      end
    end
    for panel in @page.m_selectpanels
      for tag in panel.tags
        tag.destroy
      end
      for option in panel.options
        @options.push(option.option_title)
      end
    end
  end

  def update
    @session_user = User.find(session[:user_id])
    @page = @session_user.page

    if !((params[:page][:pictures_attributes]).nil?)
      for picture_attribute in params[:page][:pictures_attributes]
        uploaded = picture_attribute[1][:photo]
        if !(uploaded.nil?)
          File.open(Rails.root.join('app', 'assets', 'images', uploaded.original_filename), 'wb') do |file|
            file.write(uploaded.read)
          end
          picture_panel = Picture.find_by_id(picture_attribute[1][:id])
          if !(picture_panel.nil?)
            picture_panel.background_file = uploaded.original_filename
          end
        end
      end
    end

    if @page.update(page_params)
      create_json(@page)
      redirect_to @session_user, alert: "Successfully updated page."
    else
      redirect_to action: 'edit', alert: "Could not update. Please try again."
    end
  end

  private

  def page_params
    params.require(:page).permit(
      :user_id, :site_name, :description, :display_description,
      text_panels_attributes: [:id, :page_id, :panel_name, :display, :info, :_destroy,
        tags_attributes: [:id, :page_id, :panel_id, :panel_type, :name, :value, :_destroy]],
        pictures_attributes: [:id, :page_id, :panel_name, :display, :description, :background_file, :_destroy,
          tags_attributes: [:id, :page_id, :panel_id, :panel_type, :name, :value, :_destroy]],
          s_selectpanels_attributes: [:id, :page_id, :panel_name, :display, :info, :_destroy,
            options_attributes: [:id, :selectpanel_id, :selectpanel_type, :option_title, :icon, :_destroy],
            tags_attributes: [:id, :page_id, :panel_id, :panel_type, :name, :value, :_destroy]],
            m_selectpanels_attributes: [:id, :page_id, :panel_name, :display, :info, :_destroy,
              options_attributes: [:id, :selectpanel_id, :selectpanel_type, :option_title, :icon, :_destroy],
              tags_attributes: [:id, :page_id, :panel_id, :panel_type, :name, :value, :_destroy]])
  end

  def create_json(page)
    page_hash = { "type" => "home2", "menu_title" => "Home" }
    File.open(Rails.root.join('public', page.site_name), 'wb') do |file|
      file.write(page_hash.to_json)
    end
  end
end
