class SitesController < ApplicationController

  def create
  end

  def show
    @site = Site.find(params[:id])
    @page = @site.page
    @panels = Array.new
    for panel in @page.panels
      if(find_selected(panel, []) == 1)
        @panels.push(panel);
      end
    end
  end

  def select
    @site = Site.find(params[:id])
    @page = @site.page
    @panels = Array.new
    selected = params[:selected]
    for panel in @page.panels 
      if (find_selected(panel, selected) == 1)
        @panels.push([panel, 1]);  
      else
        @panels.push([panel, 0]);
      end
    end
    render :json => @panels
  end

  private

  #Returns true if one of the panel's tags is selected
  def find_selected(panel, selected)
    for tag in panel.tags
      if tag.value == 1 #if the tag has a value of 1
        if tag.name == "Always"
          return 1
        end
        if selected.include?(tag.name)
          return 1
        end
      end
    end
    return 0    
  end
end
