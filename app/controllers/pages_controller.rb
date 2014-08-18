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
    @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: 201, acl: :public_read)
  end

  def create
    @session_user = User.find(session[:user_id])
    @page = Page.new(page_params)
    file_upload(params[:page][:pictures_attributes], @page.pictures)
    if !((params[:page][:s_selectpanels_attributes]).nil?)
      for panel in params[:page][:s_selectpanels_attributes]
        for select_panel in @page.s_selectpanels
          if select_panel.panel_name == panel[1][:panel_name]
            file_upload(panel[1][:options_attributes], select_panel.options)
          end
        end
      end
    end
    if !((params[:page][:m_selectpanels_attributes]).nil?)
      for panel in params[:page][:m_selectpanels_attributes]
        for select_panel in @page.m_selectpanels
          if select_panel.panel_name == panel[1][:panel_name]
            file_upload(panel[1][:options_attributes], select_panel.options)
          end
        end
      end
    end
    if @page.save
      @session_user.page = @page
      @page.site = Site.new
      redirect_to @page.site
      #redirect_to @session_user, notice: "Successfully created page."
    else
      redirect_to action: 'new', alert: "Invalid form. Please try again."
    end
  end

  def edit
    @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: 201, acl: :public_read)
    @session_user = User.find(session[:user_id])
    @page = @session_user.page

    #Creates an array of existing select options
    @options = Array.new
    @options.push("Always");
    for panel in Panel.find(:all) 
      if panel.page_id == @page.id
        if (panel.type == "SSelectpanel") || (panel.type == "MSelectpanel")
          for option in panel.options
            @options.push(option.option_title)
          end
        end
      end
    end

    #Deletes tags whose panels have been deleted and whose options have been deleted/edited
    panel_ids = Array.new
    tags = Array.new
    for panel in @page.panels.order(:created_at)
      panel_ids.push(panel.id)
      for tag in panel.tags.order(:created_at)
        tags.push(tag)
      end
    end
    for tag in tags
      if !(panel_ids.include?(tag.panel_id)) || !(@options.include?(tag.name))
        tag.destroy
      end
    end
  end

  def update
    @session_user = User.find(session[:user_id])
    @page = @session_user.page

    file_upload(params[:page][:pictures_attributes], @page.pictures)
    if !((params[:page][:s_selectpanels_attributes]).nil?)
      for panel in params[:page][:s_selectpanels_attributes]
        for select_panel in @page.s_selectpanels
          if select_panel.panel_name == panel[1][:panel_name]
            file_upload(panel[1][:options_attributes], select_panel.options)
          end
        end
      end
    end
    if !((params[:page][:m_selectpanels_attributes]).nil?)
      for panel in params[:page][:m_selectpanels_attributes]
        for select_panel in @page.m_selectpanels
          if select_panel.panel_name == panel[1][:panel_name]
            file_upload(panel[1][:options_attributes], select_panel.options)
          end
        end
      end
    end
    if @page.update(page_params)
      redirect_to @page.site
      #redirect_to @session_user, alert: "Successfully updated page."
    else
      redirect_to action: 'edit', alert: "Could not update. Please try again."
    end
  end

  #Generate new set of tags
  def tag
    @session_user = User.find(session[:user_id])
    @page = @session_user.page
    @tags = Array.new 
    for panel in @page.panels.order(:created_at)
      if panel.id > (params[:panelid]).to_i 
        tag = Tag.new
        tag.name = params[:tagname]
        tag.value = 0
        tag.page_id = @page.id
        tag.panel_id = panel.id
        tag.panel_type = panel.type
        @tags.push([tag, panel.type])
      end
    end

    render :json => @tags
  end

  private

  def page_params
    params.require(:page).permit(
      :user_id, :site_name, :description, :display_description,
      panels_attributes: [:id, :page_id, :panel_name, :display, :info, :_destroy, :file, :type, :panel_type,
        options_attributes: [:id, :info,  :selectpanel_id, :selectpanel_type, :option_title, :file, :_destroy],
        tags_attributes: [:id, :page_id, :panel_id, :panel_type, :name, :value, :_destroy]],
        text_panels_attributes: [:id, :page_id, :panel_name, :display, :info, :_destroy,
          tags_attributes: [:id, :page_id, :panel_id, :panel_type, :name, :value, :_destroy]],
          pictures_attributes: [:id, :page_id, :panel_name, :display, :info, :file, :_destroy,
            tags_attributes: [:id, :page_id, :panel_id, :panel_type, :name, :value, :_destroy]],
            s_selectpanels_attributes: [:id, :page_id, :panel_name, :display, :info, :_destroy,
              options_attributes: [:id, :info, :selectpanel_id, :selectpanel_type, :option_title, :file, :_destroy],
              tags_attributes: [:id, :page_id, :panel_id, :panel_type, :name, :value, :_destroy]],
              m_selectpanels_attributes: [:id, :page_id, :panel_name, :display, :info, :_destroy,
                options_attributes: [:id, :info, :selectpanel_id, :selectpanel_type, :option_title, :file, :_destroy],
                tags_attributes: [:id, :page_id, :panel_id, :panel_type, :name, :value, :_destroy]])
  end

  def file_upload(parameter, array)
    if !((parameter).nil?)
      for attribute in parameter
        uploaded = attribute[1][:photo]
        if !(uploaded.nil?)
          #File.open(Rails.root.join('app', 'assets', 'images', uploaded.original_filename), 'wb') do |file|
          #  file.write(uploaded.read)
          #end
          #AWS::S3::S3Object.store(uploaded, uploaded.read, ENV['S3_BUCKET'], :access=> :public_read)
          for panel in array
            if array == @page.pictures
              if panel.panel_name == attribute[1][:panel_name]
                panel.file = uploaded #.original_filename
              end
            else
              if panel.option_title == attribute[1][:option_title]
                panel.file = uploaded #uploaded.original_filename
              end
            end
          end
        end
      end
    end
  end
end
