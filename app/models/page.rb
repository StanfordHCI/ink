class Page < ActiveRecord::Base
  validates :site_name, presence: true
  validates :panel_name, presence: true
  belongs_to :user
end
