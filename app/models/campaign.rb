# == Schema Information
#
# Table name: campaigns # 活动表
#
#  id                   :integer          not null, primary key
#  name                 :string                                 # 名称
#  price                :decimal(14, 2)   default(0.0)          # 报名费
#  content              :text                                   # 内容
#  start_time           :datetime                               # 预计开始时间
#  end_time             :datetime                               # 预计结束时间
#  sign_up_end_time     :datetime                               # 报名截止时间
#  start_at             :datetime                               # 活动开始时间
#  end_at               :datetime                               # 活动结束时间
#  state                :integer          default("show")       # 状态，1：展示 2：隐藏
#  project_id           :integer                                # 关联项目ID
#  campaign_category_id :integer                                # 活动分类ID
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  sign_up_start_time   :datetime                               # 报名开始时间
#  number               :integer                                # 报名限制人数
#  remark               :string                                 # 报名表备注
#  sign_up_state        :integer                                # 报名状态 1:未开始报名 2:报名中 3:报名结束
#  campaign_state       :integer                                # 活动状态 1:活动未开始 2:活动进行中 3:活动已结束
#

# 活动
class Campaign < ApplicationRecord
  belongs_to :project, optional: true
  belongs_to :campaign_category
  has_many :campaign_enlists, dependent: :destroy

  validates :name, :content, presence: true

  enum state: {show: 1, hidden: 2} # 状态：1:启用 2:禁用
  default_value_for :state, 1

  enum campaign_state: {campaign_not_start: 1, campaign_in_process: 2, campaign_finished: 3} # 活动状态 1:活动未开始 2:活动进行中 3:活动已结束
  default_value_for :campaign_state, 1

  enum sign_up_state: {sign_up_not_start: 1, sign_up_in_process: 2, sign_up_finished: 3} # 报名状态 1:未开始报名 2:报名中 3:报名结束
  default_value_for :sign_up_state, 1

  scope :sorted, ->{ order(created_at: :desc) }

  attr_accessor :image_id

  include HasAsset
  has_one_asset :image, class_name: 'Asset::CampaignImage'
  has_one_asset :banner, class_name: 'Asset::CampaignBanner'

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :campaign_state, :sign_up_state)
      json.apply_end_time self.sign_up_end_time.strftime('%Y年%m月%d日')
      json.price self.price.to_i
      json.banner self.try(:image).try(:file_url)
    end.attributes!
  end

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :number, :campaign_state, :sign_up_state)
      json.start_time self.start_time.strftime('%Y年%m月%d日')
      json.end_time self.end_time.strftime('%Y年%m月%d日')
      json.price self.price.to_i
      json.banner self.try(:image).try(:file_url)
    end.attributes!
  end

end
