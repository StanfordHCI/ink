class Page < ActiveRecord::Base
  belongs_to :user
  has_many :text_panels
  has_many :pictures
  has_many :s_selectpanels
  accepts_nested_attributes_for :text_panels, allow_destroy: true
  accepts_nested_attributes_for :pictures, allow_destroy: true
  accepts_nested_attributes_for :s_selectpanels, allow_destroy: true

  validates :site_name, presence: true
  #accepts_nested_attributes_for :panels, :reject_if => lambda {|a| a[:panel_name].blank? }, :allow_destroy => true
end
