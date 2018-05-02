# == Schema Information
#
# Table name: camps # 探索营
#
#  id         :integer          not null, primary key
#  name       :string                                 # 名称
#  province   :string                                 # 省
#  city       :string                                 # 市
#  district   :string                                 # 区、县
#  fund_id    :integer                                # 资金id
#  manager_id :integer                                # 负责人id
#  state      :integer                                # 状态：1:启用 2:禁用）
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Camp < ApplicationRecord
  belongs_to :fund
  belongs_to :manager, class_name: 'User', foreign_key: :manager_id
  has_many :applies, class_name: 'ProjectSeasonApply', dependent: :restrict_with_error
  has_many :users
  has_many :camp_project_resources
  has_many :apply_camps, class_name: 'ProjectSeasonApplyCamp'

  validates :name, :province, :city, :district, presence: true

  enum state: {enable: 1, disable: 2} #状态 1:启用 2:禁用
  default_value_for :state, 1

  scope :sorted, ->{ order(created_at: :desc)}

  def simple_address
    ChinaCity.get(self.province).to_s + " " + ChinaCity.get(self.city).to_s + " " + ChinaCity.get(self.district).to_s
  end

  def self.address_group
    Jbuilder.new do |json|
      json.city self.city_group
    end.attributes!
  end

  def self.city_group
    cities = self.enable.pluck('distinct city').compact
    cities.map{|key| {value: key, name: ChinaCity.get(key), district: self.district_group(key)}}
  end

  def self.district_group(city)
    self.enable.where(city: city).group_by {|item| item.district}.keys.map {|key| {value: key, name: ChinaCity.get(key)}}
  end

end
