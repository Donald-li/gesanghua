# == Schema Information
#
# Table name: sms_codes
#
#  id         :integer          not null, primary key
#  kind       :integer
#  mobile     :string
#  code       :string
#  state      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'custom_validators'
class SmsCode < ApplicationRecord
  enum kind: {signup: 1, find_password: 2, change_mobile: 3, verify_profile: 4, login: 5}
  enum state: {sent: 1, verified: 2}
  default_value_for :state, 1

  validates :mobile, presence: true, mobile: true
  validates :code, presence: true#, format: {with: /\A\d{4}\z/}

  def self.random
    str =""
    1.upto(4){str << rand(10).to_s}
    str
  end

  def self.send_code(mobile, kind='signup')
    if valid_mobile?(mobile, kind)
      code = self.create(kind: kind, mobile: mobile, code: random)
      code.send_message if code.valid? && Settings.send_sms == 'true'
    else
      code = self.new(mobile: mobile, kind: kind, code: random)
      code.errors.add(:mobile, '您已发送过验证码，请输入验证码，或者1分钟后再次请求')
    end
    code
  end

  # 验证手机号码，判断之前最后一次验证是否早于1分钟
  def self.valid_mobile?(mobile, kind="signup")
    code = self.where(mobile: mobile, kind: self.kinds[kind]).last
    return (code.blank? or (code.created_at < 1.minutes.ago))
  end

  # 验证手机号码，判断5分钟内是否已经发送过验证码,并且能够匹配
  def self.valid_code?(mobile: nil, code: nil, kind: 'signup', write_verified: false)
    sms_code = self.where(mobile: mobile, kind: self.kinds[kind]).last
    return false if sms_code.blank?
    if sms_code.created_at > 5.minutes.ago and sms_code.code == code
      sms_code.set_verified if write_verified
      return true
    else
      return false
    end
  end

  def send_message
    case self.kind.to_s
    when 'signup'
      Sms.to self.mobile, code #  "【#{Settings.site_name}】验证码为#{code}，有效时间5分钟，请在页面中输入以完成验证。"
    when 'find_password'
      Sms.to self.mobile, code #  "【#{Settings.site_name}】验证码为#{code}，有效时间5分钟，请在页面中输入以完成验证。"
    when 'change_mobile'
      Sms.to self.mobile, code #  "【#{Settings.site_name}】验证码为#{code}，有效时间5分钟，请在页面中输入以完成验证。"
    when 'verify_profile'
      Sms.to self.mobile, code #  "【#{Settings.site_name}】验证码为#{code}，有效时间5分钟，请在页面中输入以完成验证。"
    end
  end

  def set_verified
    self.state = "verified"
    self.save
  end
end
