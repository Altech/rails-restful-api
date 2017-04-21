 module Api
  class PreloadRule
    def initialize
      @attributes, @associations = {}, {}
    end

    attr_accessor :attributes, :associations

    def attribute(name, includes:)
      unless name.is_a?(Symbol)
        raise TypeError.new("Expected Symbol, but got #{name.class}")
      end
      unless includes.is_a?(Symbol)
        raise TypeError.new("Expected Symbol, but got #{includes.class}")
      end

      attributes[name] = { includes: includes }
    end

    def association(name, includes: nil, serializer: nil)
      unless name.is_a?(Symbol)
        raise TypeError.new("Expected Symbol, but got #{name.class}")
      end
      unless includes.nil? || includes.is_a?(Symbol)
        raise TypeError.new("Expected Symbol, but got #{includes.class}")
      end
      unless serializer.nil? || serializer.is_a?(String) || (serializer.is_a?(Class) && serializer <= ActiveModel::Serializer)
        raise TypeError.new("Expected String of class name or an ancestor of ActiveModel::Serializer, but got #{serializer.class}")
      end

      # Assume association name to include
      includes ||= name

      associations[name.to_sym] = { includes: includes, serializer: serializer }
    end
  end
end
