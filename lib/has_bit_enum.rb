module HasBitEnum
  extend ActiveSupport::Concern

  included do |base|
  end

  module ClassMethods
    def has_bit_enum(key='key', enums=[], names={})
      key = key.to_s
      define_method("#{key.pluralize}=") do |items|
        items = [*items].map { |r| r.to_s }
        self.send("#{key.pluralize}_mask=", (items & enums).map { |r| 2**enums.index(r) }.inject(0, :+))
      end

      define_method("#{key.pluralize}") do
        enums.reject do |r|
          ((self.send("#{key.pluralize}_mask").to_i || 0) & 2**enums.index(r.to_s)).zero?
        end
      end

      define_method("#{key.pluralize}_name") do
        enums.reject do |r|
          ((self.send("#{key.pluralize}_mask").to_i || 0) & 2**enums.index(r.to_s)).zero?
        end.map{|e| names[e.to_s]}
      end

      define_method("has_#{key}?") do |item|
        (self.send("#{key.pluralize}") & [item].compact.flatten.map(&:to_s)).present?
      end

      define_method("add_#{key}") do |item|
        self.send("#{key.pluralize}=", self.send("#{key.pluralize}").push(item.to_s).uniq)
      end

      define_method("remove_#{key}") do |item|
        self.send("#{key.pluralize}=", self.send("#{key.pluralize}") - [item.to_s])
      end
    end

  end
end
