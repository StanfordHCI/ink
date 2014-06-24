class PanelsController < ApplicationController

  def create
    @panel = Panel.new
    @panel.panel_name = params[:panel_name]
    @panel.display = params[:display]
    @panel.panel_type = params[:panel_type]
    
    uploaded = params[:background]
    if !(uploaded.nil?)
      File.open(Rails.root.join('app','assets','images', uploaded.original_filename), 'wb') do |file|
        file.write(uploaded.read)
      end
    @panel.background_file = params[:background].original_filename
    end
  end
end
