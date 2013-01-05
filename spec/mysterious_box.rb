class MysteriousBox
  extend Manhattan

  attr_accessor :status

  has_statuses :opened, :closed, :glowing

  def before_glowing
    "Expectations"
  end

  def after_closed
    "Dreams"
  end

end
