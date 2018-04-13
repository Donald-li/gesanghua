# -*- encoding : utf-8 -*-
module ActiveRecord

  class Base
    #enum的辅助方法
    def self.options_for_enum_select(enum, raw: false)
      if raw
        enums_for(enum).map{|e| [e.second, e.third]}
      else
        enums_for(enum).map{|e| [e.second, e.first]}
      end
    end

    def self.options_for_select(enum, raw: false)
      self.options_for_enum_select(enum, raw: raw)
    end

    def self.options_for_some_select(enum, array=[], raw: false)
      if raw
        if array != []
          enums_for(enum).map{|e| [e.second, e.third] if array.include?(e.first)}.compact
        else
          enums_for(enum).map{|e| [e.second, e.third]}
        end
      else
        if array != []
          enums_for(enum).map{|e| [e.second, e.first] if array.include?(e.first)}.compact
        else
          enums_for(enum).map{|e| [e.second, e.first]}
        end
      end
    end

    def self.enums_for(enum)
      self.send(enum).map{|k,v| [k, I18n.t("#{self.name.underscore}_#{enum}.#{k}"), v]}
    end

    def self.enum_name(enum, value)
      I18n.t("#{self.name.underscore}_#{enum.to_s.pluralize}.#{value}")
    end

    def enum_name(enum)
      return '' if self.send(enum).blank?
      I18n.t("#{self.class.name.underscore}_#{enum.to_s.pluralize}.#{self.send enum}")
    end

    ##通过身份证号计算年龄
    def get_age(data)
      birthday = ChinesePid.new(data).birthday
      Date.today.year - birthday.year if birthday.present?
    end

  end
end
