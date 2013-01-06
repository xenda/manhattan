class MysteryBox < ActiveRecord::Base
  include Manhattan
  attr_accessible :status
  has_statuses :opened, :closed, :glowing, column_name: "status", default_value: :opened

  def before_glowing
    "Expectations"
  end

  def after_closed
    "Dreams"
  end
end
