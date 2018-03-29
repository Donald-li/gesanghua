# == Schema Information
#
# Table name: teams # 小组
#
#  id                    :integer          not null, primary key
#  name                  :string                                 # 名称
#  member_count          :integer                                # 会员数
#  current_donate_amount :decimal(14, 2)   default(0.0)          # 当前捐助金额
#  total_donate_amount   :decimal(14, 2)   default(0.0)          # 捐助总额
#  creater_id            :integer                                # 团队创建人id
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  team_no               :string                                 # 团队编号
#  kind                  :integer                                # 分类：社会（society）高校（college）
#  province              :string                                 # 省
#  city                  :string                                 # 市
#  district              :string                                 # 区县
#  address               :string                                 # 详细地址
#  describe              :text                                   # 简介
#  school_name           :string                                 # 高校名称
#  manage_id             :integer                                # 负责人
#

# 团队
class Team < ApplicationRecord
  belongs_to :creater, class_name: 'User', foreign_key: 'creater_id'
  belongs_to :manager, class_name: 'User', foreign_key: 'manage_id', optional: true

  has_many :users
  has_many :donate_records

  include HasAsset
  has_one_asset :logo, class_name: 'Asset::TeamLogo'

  scope :sorted, ->{ order(created_at: :desc) }

  enum kind: {society: 1, college: 2} # 1.社会（society）2.高校（college）

  default_value_for :member_count, 0

  before_create :gen_team_no

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :kind, :member_count, :total_donate_amount, :describe, :creater_id, :manage_id)
      json.city_name ChinaCity.get(self.city)
      json.district_name ChinaCity.get(self.district)
      json.create_time self.created_at.strftime("%Y-%m-%d %H:%M")
      json.creater_name self.creater.try(:nickname)
      json.creater_avatar_url self.creater.user_avatar
      json.manager_name self.manager.try(:nickname)
      json.manager_avatar_url self.manager.user_avatar
      json.logo_mode self.logo.present?
      json.logo_url self.logo_url(:small).to_s
    end.attributes!
  end

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :address, :describe)
      json.logo_mode self.logo.present?
      json.logo_url self.logo_url(:small).to_s
      json.logo do
        json.id self.try(:logo).try(:id)
        json.url self.try(:logo).try(:file_url)
        json.protect_token ''
      end
      json.location [self.province, self.city, self.district]
    end.attributes!
  end

  def user_status(user_id)
    if self.users.pluck(:id).include?(user_id)
      if self.manage_id == user_id
        status = 0
      else
        status = 1
      end
    else
      status = 2
    end
    return status
  end

  private
  def gen_team_no
    self.team_no ||= Sequence.get_seq(kind: :team_no, prefix: 'T', length: 6)
  end

end
