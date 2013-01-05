require "manhattan/version"

module Manhattan

  def has_statuses(*statuses)
    @statuses_names = localize_names(statuses)

    statuses.each_with_index do |status, index|
      add_to_statuses_hash(status, index)
      create_query_methods(status)
    end

    create_status_accessors
  end

  private

  def localize_names(args)
    args.map(&:to_s)
  end

  def add_to_statuses_hash(status, index)
    @statuses ||= {}
    @statuses[status] = @statuses_names[index]
  end

  def create_query_methods(status)
    define_query_methods(status)
    define_mark_method(status)
  end

  def define_query_methods(status)

    query                      = "#{status}?".to_sym
    negative_query             = "not_#{query}".to_sym
    alternative_negative_query = "un#{query}".to_sym
    alternate_negative_query = "in#{query}".to_sym

    define_method query do
      self.status == self.class.status(status.to_sym)
    end

    define_method negative_query do
      !self.send(query)
    end
    alias_method alternative_negative_query, negative_query
    alias_method alternate_negative_query, negative_query
  end

  def define_mark_method(status)

    marking_name      = "mark_as_#{status}".to_sym
    before_marking    = "before_#{status}".to_sym
    after_marking     = "after_#{status}".to_sym

    define_method marking_name do
      send_if_exists(before_marking)
      self.status = self.class.status(status)
      send_if_exists(:save)
      send_if_exists(after_marking)
    end
  end


  def create_status_accessors
    class << self
      define_method "status" do |queried_status|
        @statuses[queried_status]
      end
      define_method "statuses" do
        @statuses.values
      end
    end
    define_method "statuses" do
      self.class.statuses
    end

    define_method :send_if_exists do |method|
      self.send(method) if self.respond_to? method
    end

  end

end
