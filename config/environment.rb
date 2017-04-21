# Load the Rails application.
require_relative 'application'

# Delete serializer hook to use locally(i.e. api/v2)
# hook: https://github.com/rails-api/active_model_serializers/blob/master/lib/active_model_serializers/railtie.rb#L14
ActiveModelSerializers::Railtie.initializers.delete_if { |i| i.name == 'active_model_serializers.action_controller' }

# Initialize the Rails application.
Rails.application.initialize!
