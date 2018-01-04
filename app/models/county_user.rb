# == Schema Information
#
# Table name: county_users
#
#  id            :integer          not null, primary key
#  name          :string                                 # 姓名
#  phone         :string                                 # 联系方式
#  unit_name     :string                                 # 单位名称
#  unit_describe :string                                 # 单位简介
#  user_id       :integer                                # 用户id
#  address       :string                                 # 详细地址
#  province      :string                                 # 省
#  city          :string                                 # 市
#  district      :string                                 # 区/县
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'custom_validators'
class CountyUser < ApplicationRecord
  belongs_to :user, optional: true

  validates :phone, mobile: true

  scope :sorted, ->{ order(created_at: :desc) }
end
