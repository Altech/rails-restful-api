module ActiveModel
  class Serializer
    # @api private
    def relationship_value_for(association, adapter_options, adapter_instance)
      return association.options[:virtual_value] if association.options[:virtual_value]
      association_serializer = association.serializer
      association_object = association_serializer && association_serializer.object
      return unless association_object

      # [Note] @Altech
      # Add this clause to provide selective fields for associations.
      # Becuase attribute adapter doens't provide to select fields
      # of nested associations. We should suggest PR to the gem.
      # related issue: https://github.com/rails-api/active_model_serializers/issues/1895
      if adapter_options[:include] && adapter_options[:include][association.key]
        fields = (adapter_options[:include][association.key][:only] || []) | [:id]
        adapter_options[:include] = adapter_options[:include][association.key]
        options = {fields: fields}
      else
        # original behavior
        options = {}
      end

      relationship_value = association_serializer.serializable_hash(adapter_options, options, adapter_instance)

      if association.options[:polymorphic] && relationship_value
        polymorphic_type = association_object.class.name.underscore
        relationship_value = { type: polymorphic_type, polymorphic_type.to_sym => relationship_value }
      end

      relationship_value
    end
  end
end
