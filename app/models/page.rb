class Page < ActiveRecord::Base
  validates :site_name, presence: true

  belongs_to :user
  has_many :panels, :dependent => :destroy
  accepts_nested_attributes_for :panels
end
