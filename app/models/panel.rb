class Panel < ActiveRecord::Base
  belongs_to :page, inverse_of: :panels
  validates_presence_of :page
end
