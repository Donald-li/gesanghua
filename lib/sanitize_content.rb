require 'active_support/concern'

module SanitizeContent
  # include ActionView::Helpers::SanitizeHelper
  extend ActiveSupport::Concern

  included do |base|
    cattr_accessor :sanitize_content_attrs

    include InstanceMethods
    before_save :sanitize_content
  end

  module ClassMethods
    def sanitize_content(*attrs)
      self.sanitize_content_attrs = attrs
    end
  end

  module InstanceMethods
    def sanitize_content
      sanitize_content_attrs.each do |attr|
        next unless self.send("#{attr}_changed?")
        self.send "#{attr}=", ActionController::Base.helpers.sanitize(self.attributes[attr.to_s].to_s, tags: %w(img br p), attributes: %w(src)).gsub('<p>', '').gsub('</p>', '<br/>')
      end
    end
  end
end