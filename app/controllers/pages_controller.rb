class PagesController < ApplicationController

  def index
  end

  def new
    @new_page = Page.new
  end

  def create
  end
end
