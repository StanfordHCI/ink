class Tag < ActiveRecord::Base
  belongs_to :panel, polymorphic: true
end
