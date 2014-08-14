class Site < ActiveRecord::Base
  def to_param
    "#{id} #{name}".parameterize
  end
  belongs_to :page
end
