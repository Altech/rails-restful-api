module Api
  class Preloader
    # @param [Array] attributes   fields to select.
    # @param [Hash]  associations associations to include and fields to select of them.
    # @example When you select id and name from companies,
    #   preload_for(companies, [:id, :name], {})
    # @example When you includes posts and employees and employees avatar,
    #   preload_for(companies, [], {posts: {}, employees: {avatar: {}}})
    def self.preload_for(rel, attributes, associations)
      unless rel.is_a?(ActiveRecord::Relation)
        raise TypeError.new("Expected ActiveRecord::Relation, but got #{rel.class}")
      end
      attributes ||= []
      associations ||= {}

      model = rel.klass
      serializer = get_serializer(model)

      preloader = self.new(rel, model, serializer, attributes, associations)
      preloader.perform!
      preloader.rel
    end

    def self.get_serializer(klass)
      serializer = ActiveModel::Serializer.serializer_for(klass.new)
      unless serializer
        raise SerializerNotFound.new(klass)
      end
      serializer
    end

    def initialize(rel, model, serializer, attributes, associations, chain = [])
      unless serializer.is_a?(Class) && serializer <= ActiveModel::Serializer
        raise TypeError.new("Expected a descendant of ActiveModel::Serializer, but got #{serializer}")
      end

      @rel, @model, @serializer, @attributes, @associations, @chain = rel, model, serializer, attributes, associations, chain
    end

    attr_accessor :rel, :model, :serializer, :attributes, :associations

    def perform!
      return unless serializer.preload_rule
      attributes.each do |attribute|
        preload_for_attribute!(attribute)
      end

      associations.each do |association, nested|
        preload_for_association!(association, nested)
      end

      nil
    end

    private

    def preload_for_attribute!(attribute)
      rule = serializer.preload_rule.attributes[attribute]
      return unless rule

      self.rel = self.rel.includes(includes_on_chain(rule[:includes]))
    end

    def preload_for_association!(association, nested)
      rule = serializer.preload_rule.associations[association]
      return unless rule

      ar_association = rule[:includes] || association
      old = self.rel
      self.rel = self.rel.includes(includes_on_chain(ar_association))
      # binding.pry if self.rel.nil?

      if nested.present?
        nested = nested.dup
        nested_attributes = nested.delete(:only) || []
        nested_associations = nested

        association_object = model.reflections[ar_association.to_s]
        unless association_object
          raise "Could not find association(#{ar_association}) from class(#{model})"
        end
        nested_model = association_object.klass
        case rule[:serializer]
        when NilClass
          rule[:serializer] = self.class.get_serializer(nested_model)
        when String
          rule[:serializer] = const_get(rule[:serializer])
          unless rule[:serializer].is_a?(Class) && rule[:serializer] <= ActiveModel::Serializer
            raise TypeError.new("Expected a descendant of ActiveModel::Serializer, but got #{rule[:serializer]}")
          end
        end

        preloader = self.class.new(self.rel, nested_model, rule[:serializer], nested_attributes, nested_associations, (@chain + [ar_association]))
        preloader.perform!
        self.rel = preloader.rel
      end
    end

    # @example When `@chain` is [:jobs, :employee],
    #   includes_on_chain(:avatar) #=> {:jobs=>{:employees=>{:avatar=>{}}}}
    def includes_on_chain(association)
      hash = {}
      (@chain + [association]).inject(hash) { |hash, association|
        hash[association] = {}
      }
      hash
    end

    class SerializerNotFound < StandardError
      def initialize(klass)
        @klass = klass
      end

      def message
        "Serializer was not found for class: #{klass.name}"
      end
    end
  end
end
