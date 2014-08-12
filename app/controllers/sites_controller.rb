class SitesController < ApplicationController

  def create
  end

  def show
    @site = Site.find(params[:id])
    @page = @site.page
    @panels = Array.new
    for panel in @page.panels
      if(find_selected(panel, [])[0] == 1)
        @panels.push(panel);
      end
    end
  end

  def select
    @site = Site.find(params[:id])
    @page = @site.page
    @panels = Array.new
    selected = params[:selected]
    for panel in @page.panels.reverse_each 
      test = Array.new
      test = find_selected(panel, selected);
      if (test[0] == 1)
        options = Array.new
        if (panel.type == "SSelectpanel" || panel.type == "MSelectpanel") 
          options = panel.options
        end
        @panels.push([panel, 1, panel.type, options, test[1]])  
      else
        @panels.push([panel, 0, panel.type, options])
      end
    end
    render :json => @panels
  end

  private

  #Returns true if one of the panel's tags is in selected_tags
  def find_selected(panel, selected)
    for tag in panel.tags
      if tag.value == 1 #if the tag has a value of 1
        if tag.name == "Always"
          return [1, tag.name]
        end
        if selected.include?(tag.name)
          return [1, tag.name]
        end
      end
    end
    return [0, ""]
  end
end
