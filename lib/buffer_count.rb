# version: 0.1
require 'active_support/concern'
module BufferCount
  extend ActiveSupport::Concern
  included do
    include InstanceMethods
  end

  class_methods do
    # :delay => 20
    def has_buffer_count(options = {})
      cattr_accessor :buffer_count_group
      self.buffer_count_group ||= {}
      group = options[:column].try(:to_sym) || :views_count
      self.buffer_count_group[group] ||= {}
      self.buffer_count_group[group][:delay] =  options[:delay] || 100
      self.buffer_count_group[group][:key] = "models/#{self.to_s.tableize}/#{group}_cache/"

      define_method(group) do
        self.buffer_count_real(group)
      end
    end
  end

  module InstanceMethods
    def hit!(column = :views_count, by = 1)
      self.increment_buffer_count(column = column, by = by)
    end

    def increment_buffer_count(column = :views_count, by = 1)
      cache_key = "#{buffer_count_group_key(column)}#{self.id}"
      buffer_count = Rails.cache.read(cache_key) || 0

      if buffer_count >= buffer_count_group[column.to_sym][:delay]
        self.update_column(column, (self.attributes[column.to_s] || 0) + buffer_count)
    	  Rails.cache.write(cache_key, 0)
  	  else
    	  Rails.cache.write(cache_key, buffer_count + by)
      end
    end

    def buffer_count_real(column = :views_count)
      buffer_count = Rails.cache.read("#{buffer_count_group_key(column)}#{self.id}") || 0
      return (self.attributes[column.to_s] || 0) + buffer_count.to_i
    end

    def buffer_count_group_key(column = :views_count)
      buffer_count_group[column.to_sym][:key]
    end
  end
end
