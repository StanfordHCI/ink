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
    file_upload(params[:page][:left_pic_textpanels_attributes], @page.left_pic_textpanels)
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
    for panel in @page.panels.order(:created_at)
      if (panel.type == "SSelectpanel") || (panel.type == "MSelectpanel")
        if panel.options
          for option in panel.options.order(:created_at)
            @options.push(option.option_title)
          end
        end
      end
    end

    #Deletes tags whose panels have been deleted and whose options have been deleted/edited
    panel_ids = Array.new
    tags = Array.new
    puts "TAGS"
    puts tags
    for panel in @page.panels.order(:created_at)
      panel_ids.push(panel.id)
    end
    Tag.find_each(conditions: {page_id: @page.id}) do |tag|
      if !(panel_ids.include?(tag.panel_id)) || !(@options.include?(tag.name))
        tag.destroy
      end
    end
  end

  def update
    @session_user = User.find(session[:user_id])
    @page = @session_user.page

    file_upload(params[:page][:pictures_attributes], @page.pictures)
    file_upload(params[:page][:left_pic_textpanels_attributes], @page.left_pic_textpanels)
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
      puts("PAGE_PARAMS")
      puts(page_params)

      if request.xhr? #Called by AJAX
        panel = @page.panels.order(:created_at).last #Get the most recently created panel
        fields = get_panel_preview(panel) 

        respond_to do |format|
          format.json {render json: [panel.id, panel.tags.order(:created_at), fields]} #returns the most recently created panel's id, its tags, and its preview
        end
      elsif params[:commit] == 'Publish' #Called when 'Publish' button is hit
        redirect_to @page.site
      elsif params[:commit] == 'Save' #Called when 'Save' button is hit
        redirect_to action: 'edit', alert: "Successfully updated page."
      end
    else
      puts("PAGE_PARAMS: update failed")
      puts(page_params)
      #Need to add a case for AJAX here?
      redirect_to action: 'edit', alert: "Could not update. Please try again."
    end
  end

  #Generate new set of tags
  def tag
    @session_user = User.find(session[:user_id])
    @page = @session_user.page
    @tags = Array.new 
    for panel in @page.panels.order(:created_at)
      #Use a max function on :panelid and :newpanelid?
      if !(panel_has_tag(panel, params[:tagname]))
        if panel.id > (params[:panelid]).to_i && panel.id >= (params[:newpanelid]).to_i 
          tag = Tag.new
          tag.name = params[:tagname]
          tag.page_id = @page.id
          tag.panel_id = panel.id
          tag.panel_type = panel.type
          tag.save
          @tags.push(tag)
        end
      end
    end
    render json: @tags
  end

  #Returns all panel previews as JSON
  def previews
    @session_user = User.find(session[:user_id])
    @page = @session_user.page
    panels = Array.new
    for panel in @page.panels.order(:created_at)
      fields = get_panel_preview(panel) 
      panels.push(fields)
    end
    render json: panels
  end

  #Returns last created option
  def option
    panel = Panel.find(params[:panelid])
    render json: panel.options.order(:created_at).last
  end

  #Returns all options for a page
  def options
    @session_user = User.find(session[:user_id])
    @page = @session_user.page
    options = Array.new
    for panel in @page.panels.order(:created_at)
      if panel.type == 'MSelectpanel' || panel.type == 'SSelectpanel'
        if panel.options
          for option in panel.options.order(:created_at)
            options.push(option)
          end
        end  
      end 
    end
    render json: options
  end

  private

  def panel_has_tag(panel, tag_name)
    if panel.tags
      for tag in panel.tags 
        if tag.name == tag_name
          return true
        end
      end
    end
    return false
  end

  def page_params
    params.require(:page).permit(
      :user_id, :site_name, :description, :display_description,
      panels_attributes: [:id, :page_id, :panel_name, :display, :info, :_destroy, :file, :caption, :type, :panel_type,
        options_attributes: [:id, :info, :selectpanel_id, :selectpanel_type, :option_title, :file, :_destroy],
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
        tags_attributes: [:id, :page_id, :panel_id, :panel_type, :name, :value, :_destroy]],
      left_pic_textpanels_attributes: [:id, :page_id, :panel_name, :display, :info, :file, :caption, :_destroy,
        tags_attributes: [:id, :page_id, :panel_id, :panel_type, :name, :value, :_destroy]])
  end

  def file_upload(parameter, array)
    if !((parameter).nil?)
      for attribute in parameter
        uploaded = attribute[1][:photo]
        if !(uploaded.nil?)
=begin
          # Only works if saving locally
          File.open(Rails.root.join('app', 'assets', 'images', uploaded.original_filename), 'wb') do |file|
            file.write(uploaded.read)
          end
=end
          for panel in array
            if array == @page.pictures || array == @page.left_pic_textpanels
              if panel.panel_name == attribute[1][:panel_name]
                panel.file = uploaded 
              end
            else
              if panel.option_title == attribute[1][:option_title]
                panel.file = uploaded
              end
            end
          end
        end
      end
    end
  end

  def get_panel_preview(panel)
    #Determine panel type and corresponding partial 
    if (panel.type) == 'TextPanel'
      partial = 'text_panel'
    elsif (panel.type) == 'Picture'
      partial = 'picture_panel'
    elsif (panel.type) == 'SSelectpanel'
      partial = 's_selectpanel'
    elsif (panel.type) == 'MSelectpanel' #panel is multi-select
      partial = 'm_selectpanel'
    else
      partial = 'left_pic_textpanel'
    end
    return render_to_string(partial: '/sites/'+partial, locals: {panel: panel})
  end

end
