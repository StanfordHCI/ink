class SitesController < ApplicationController

  def create
    
  end

  def show
    @site = Site.find(params[:id])
    @page = @site.page
    @site.name = @page.site_name
    @panels = Array.new
    for panel in @page.panels
      if panel_not_tagged(panel)
        @panels.push(panel)
      elsif find_selected(panel, [])
        @panels.push(panel)
      end
    end
  end

  def select
    @site = Site.find(params[:id])
    @page = @site.page
    @panels = Array.new
    selected = params[:selected]
    for panel in @page.panels.order(:created_at)
      options = Array.new
      if panel_not_tagged(panel)
        @panels.push([panel, 1, panel.type, options])
      elsif find_selected(panel, selected)
        @panels.push([panel, 1, panel.type, options])  
      else
        if (panel.type == "SSelectpanel" || panel.type == "MSelectpanel") 
          options = panel.options
        end
        @panels.push([panel, 0, panel.type, options])
      end
    end
    render json: @panels
  end

  private

  #Checks if a panel's tags are all set to 0
  def panel_not_tagged(panel)
    for tag in panel.tags
      if tag.value == 1
        return false 
      end
    end
    return true 
  end

  #Returns true if one of the panel's tags is in selected_tags
  def find_selected(panel, selected)
    for tag in panel.tags
      if tag.value == 1 #if the tag has a value of 1
        if tag.name == "Always"
          return true 
        end
        if selected.include?(tag.name)
          return true 
        end
      end
    end
    return false 
  end
end
