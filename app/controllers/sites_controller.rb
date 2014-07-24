class SitesController < ApplicationController
  
  def create
  end

  def show
    @site = Site.find(params[:id])
    @page = Page.find(@site.page.id)
  end

end
