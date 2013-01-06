class MysteryBox < ActiveRecord::Base
  include Manhattan
  attr_accessible :status
  has_statuses :opened, :closed, :glowing

  def before_glowing
    "Expectations"
  end

  def after_closed
    "Dreams"
  end
end
