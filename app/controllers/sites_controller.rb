class SitesController < ApplicationController

  def create
  end

  def show
    @session_user = User.find(session[:user_id])
    @page = @session_user.page
    @site = @page.site
    @panels = Array.new
    for panel in @page.panels
      if(find_selected(panel, []) == 1)
        @panels.push(panel);
      end
    end
    #@site = Site.find(params[:id])
    #@page = Page.find(@site.page.id)
  end

  def select
    @session_user = User.find(session[:user_id])
    @page = @session_user.page
    @site = @page.site
    @panels = Array.new
    selected = params[:selected]
    for panel in @page.panels 
      if (find_selected(panel, selected) == 1)
        @panels.push(panel);  
        #if (panel.type == "SSelectpanel") || (panel.type == "MSelectpanel")
          #@panels.push([panel, panel.type, panel.options])
        #else
          #@panels.push([panel, panel.type])
        #end
      end
    end
    respond_to do |format|
      @preview = render_to_string(:action => 'select', :locals => {:panels => @panels})
      format.json {
        render :json => {
        :results => @preview
      }
      }
      #render_to_string '/sites/show', layout: false #:json => panels
    end
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
