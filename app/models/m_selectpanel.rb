class MSelectpanel < ActiveRecord::Base
  belongs_to :page
  has_many :options, as: :selectpanel
  accepts_nested_attributes_for :options, allow_destroy: true
end
