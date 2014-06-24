class Panel < ActiveRecord::Base
  validates :panel_name, presence: true
  belongs_to :page
end
