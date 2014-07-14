class Option < ActiveRecord::Base
  belongs_to :selectpanel, polymorphic: true
end
