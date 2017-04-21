class ApplicationSerializer < ActiveModel::Serializer
  class << self
    def preload(&block)
      @preload_rule = Api::PreloadRule.new
      @preload_rule.instance_exec(&block)
      @preload_rule
    end
    attr_reader :preload_rule
  end
end
