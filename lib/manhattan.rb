require "manhattan/version"

module Manhattan

  extend ActiveSupport::Concern

  module ClassMethods

    attr_accessor :status_column_name, :default_status_value

    def has_statuses(*statuses)
      arguments = statuses.pop if statuses.last.is_a? Hash
      arguments ||= {}

      options = { column_name: :status }
      options.merge! arguments

      common_methods = statuses & self.methods
      raise Manhattan::AlreadyDefinedMethod, "Already defined method #{common_methods}" unless common_methods.empty?

      @status_column_name = options[:column_name]
      @default_status_value = options[:default_value]
      @statuses = {}
      @statuses_names = localize_names(statuses)

      after_initialize :set_default_value

      statuses.each_with_index do |status, index|
        add_to_statuses_hash(status, index)
        create_query_methods(status)
      end

    end

    def status(queried_status)
      @statuses[queried_status]
    end

    def statuses
      @statuses.values
    end

    private

    def localize_names(args)
      args.map(&:to_s)
    end

    def add_to_statuses_hash(status, index)
      @statuses[status] = @statuses_names[index]
    end

    def create_query_methods(status)
      define_query_methods(status)
      define_mark_method(status)
    end

    def define_query_methods(status)

      status_sym                 = status.to_sym
      query                      = "is_#{status}?".to_sym
      negative_query             = "is_not_#{status}?".to_sym
      alternative_negatives      = ["is_un#{status}?".to_sym, "is_in#{status}?".to_sym]

      define_method query do
        status_column_value == status_value(status_sym)
      end

      define_method negative_query do
        !self.send(query)
      end

      scope status_sym, where(@status_column_name => status(status_sym))

      alternative_negatives.each do |alternative|
        alias_method alternative, negative_query
      end

    end

    def define_mark_method(status)

      marking_name      = "mark_as_#{status}".to_sym
      before_marking    = "before_#{status}".to_sym
      after_marking     = "after_#{status}".to_sym

      define_method marking_name do
        send_if_exists(before_marking)
        self.send(status_write_method,self.class.status(status))
        self.save
        send_if_exists(after_marking)
      end
    end

  end

  def statuses
    self.class.statuses
  end

  class AlreadyDefinedMethod < StandardError; end

  def status_column_value
    self.send(self.class.status_column_name)
  end

  private

  def status_value(status)
    self.class.status(status)
  end

  def status_write_method
    "#{self.class.status_column_name}="
  end

  def default_status_value
    self.class.default_status_value
  end

  def send_if_exists(method)
    self.send(method) if self.respond_to? method
  end

  def set_default_value
    self.send(status_write_method, status_value(default_status_value)) unless self.status_column_value
  end



end
