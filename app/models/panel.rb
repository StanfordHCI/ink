class Panel < ActiveRecord::Base
  belongs_to :page
  validates_presence_of :page
end
