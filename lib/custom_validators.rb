require 'active_model'
require 'json'

class JsonValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless valid_json?(value)
      record.errors[attribute] << (options[:message] || '不是合法的JSON格式')
    end
  end

  private
  def valid_json?(json)
    JSON.parse(json)
  rescue
    false
  end
end

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.blank? || value =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
      record.errors[attribute] << (options[:message] || "邮件地址格式不正确")
    end
  end
end

class MobileValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.blank? || value =~ /^1\d{10}$/i
      record.errors[attribute] << (options[:message] || "手机号码格式不正确")
    end
  end
end

class TelValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.blank? || value =~ /^(0[0-9]{2,3}\-?)?([2-9][0-9]{6,7})+(\-[0-9]{1,4})?$/i
      record.errors[attribute] << (options[:message] || "电话号码格式不正确")
    end
  end
end

class PhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.blank? || value =~ /^(\d{11})|^((\d{7,8})|(\d{4}|\d{3})-(\d{7,8})|(\d{4}|\d{3})-(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1})|(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1}))$/i
      record.errors[attribute] << (options[:message] || "电话号码格式不正确")
    end
  end
end


class ZipcodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.blank? || value =~ /^(\d+){6}$/i
      record.errors[attribute] << (options[:message] || "邮编格式不正确")
    end
  end
end



class QqValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.blank? || value =~ /^\d{5,20}$/i
      record.errors[attribute] << (options[:message] || "QQ号码格式不正确")
    end
  end
end


class ShenfenzhengNoValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.blank? || ChinesePid.new(value).valid?
      record.errors[attribute] << (options[:message] || "身份证号码格式不正确")
    end
  end
end

class HuixiangzhengNoValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.blank? || value =~ /^[a-zA-Z0-9]{5,21}$/i
      record.errors[attribute] << (options[:message] || "回乡证号码格式不正确")
    end
  end
end

class HuzhaoNoValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.blank? || value =~ /^[a-zA-Z0-9]{5,20}$/i
      record.errors[attribute] << (options[:message] || "护照号码格式不正确")
    end
  end
end

class OrgCardNoValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.blank? || value =~ /^[xX\-\d]{8,10}$/i
      record.errors[attribute] << (options[:message] || "组织机构代码证号码格式不正确")
    end
  end
end

class MemberBirthdayValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.blank? || (value < 4.years.ago && value > 12.years.ago)
      record.errors[attribute] << (options[:message] || "年龄不合法")
    end
  end
end
