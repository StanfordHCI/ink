class Page < ActiveRecord::Base
  belongs_to :user
  has_many :panels, :dependent => :destroy
  validates :site_name, presence: true
  accepts_nested_attributes_for :panels, :reject_if => lambda {|a| a[:panel_name].blank? }, :allow_destroy => true
end
