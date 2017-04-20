module ActsAsImageable
  extend ActiveSupport::Concern

  module ImageableMethods
    extend ActiveSupport::Concern

    def images
      self.class.image_names.map { |name| send(name) }.compact
    end
  end

  module ClassMethods
    def acts_as_imageable(options = {})
      cattr_accessor :image_names

      self.image_names ||= []
      nested_attributes_options = { allow_destroy: true, reject_if: :all_blank }.merge(options[:nested_attribute_options] || {})

      (options[:image_names] - image_names).each do |image_name|
        has_one image_name, -> { where(name: image_name.to_s) }, class_name: "Image", as: :imageable
        accepts_nested_attributes_for image_name, nested_attributes_options
      end
      self.image_names |= options[:image_names]

      include ActsAsImageable::ImageableMethods
    end
  end
end
