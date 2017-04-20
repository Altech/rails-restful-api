module Api
  class RescuableError < ::StandardError

    @@used_error_codes = Set.new

    def self.[](error_code, http_status = nil)
      unless error_code.is_a?(Integer)
        raise TypeError.new('`error_code` should be an integer')
      end

      if error_code > 0
        if @@used_error_codes.include?(error_code)
          raise ArgumentError.new('error_code=%d is already in use' % [error_code])
        end

        @@used_error_codes << error_code
      end

      klass = Class.new(self)
      klass.define_singleton_method(:error_code) { error_code }
      klass.define_singleton_method(:http_status) { http_status }
      klass
    end

    def self.error_code; end
    def self.http_status; end

    def error_code
      self.class.error_code || -1
    end

    def http_status
      self.class.http_status || :unprocessable_entity
    end
  end

  # # 1xx : Used in the restful concern

  class ImplicitIncludeError < RescuableError[100, :bad_request]
    def initialize(associations)
      @associations = associations
    end

    def message
      "You will include the association(#{@associations.join('.')}) implicitly. Implicit inclusion is prohibited."
    end
  end

  class UnincludedFieldError < RescuableError[101, :bad_request]
    def initialize(field, associations)
      @associations, @field = associations, field
    end

    def message
      "You will select the field(#{@field}) of the association(#{@associations.join('.')}). But the association was not included."
    end
  end

  class SortPermissionError < RescuableError[102, :bad_request]
    def initialize(sort_columns, permitted_columns)
      @sort_columns, @permitted_columns = sort_columns, permitted_columns
    end

    def message
      "You are not permitted to sort by the columns(#{(@sort_columns - @permitted_columns).join(', ')})."
    end
  end

  # # 2xx : Used in controllers commonly

  class ValueDomainError < RescuableError[200, :bad_request]
    def initialize(name, domain:, passed_value:)
      @name, @domain, @passed_value = name, domain, passed_value
    end

    def message
      "The parameter `#{@name}` of domain is `#{@domain.inspect}`, But got value `#{@passed_value}`"
    end
  end
end
