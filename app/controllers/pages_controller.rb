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
          for panel in @page.pictures
            if panel.panel_name == picture_attribute[1][:panel_name]
              panel.background_file = uploaded.original_filename
            end
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
          for panel in @page.pictures
            if panel.panel_name == picture_attribute[1][:panel_name]
              panel.background_file = uploaded.original_filename
            end
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
    page_hash = {:title => page.site_name}
    panels = Array.new

    for panel in page.text_panels
      tags = generate_tags(panel)
      temp_hash = {:type => "basic-data-exp", :menu_title => panel.panel_name, :tags => tags}
      panels.push(temp_hash)
    end
    for panel in page.pictures
      tags = generate_tags(panel)
      temp_hash = {:type => "basic-data-exp", :menu_title => panel.panel_name, :image => panel.background_file, :tags => tags}
      panels.push(temp_hash)
    end
    for panel in page.s_selectpanels
      temp_hash = generate_select_panel(panel)
      panels.push(temp_hash)
    end
    for panel in page.m_selectpanels
      temp_hash = generate_select_panel(panel)
      panels.push(temp_hash)
    end

    page_hash = page_hash.merge(:pages => panels)

    File.open(Rails.root.join('public', page.site_name), 'wb') do |file|
      file.write(page_hash.to_json)
    end
  end

  def generate_select_panel(panel)
    options = Array.new
    for option in panel.options
      temp_option = {:title => option.option_title}
      options.push(temp_option)
    end
    tags = generate_tags(panel)
    temp_hash = {:type => "single-select", :subtitle => panel.info, :rows => "1", :columns => "3", :menu_title => panel.panel_name, :options => options, :tags => tags}
    return temp_hash
  end

  def generate_tags(panel)
    tags = Array.new
    for tag in panel.tags
      if tag.value
        tags.push(tag.name)
      end
    end
    return tags
  end

end
