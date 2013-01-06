class EmptyBox < ActiveRecord::Base
  include Manhattan
  attr_accessible :state
  has_statuses :opened, :closed, column_name: "state", default_value: :opened
end
