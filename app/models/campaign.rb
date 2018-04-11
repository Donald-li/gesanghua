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
#  state                :integer          default("show")       # 状态，1：展示 2：隐藏
#  project_id           :integer                                # 关联项目ID
#  campaign_category_id :integer                                # 活动分类ID
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  sign_up_start_time   :datetime                               # 报名开始时间
#  number               :integer                                # 报名限制人数
#  remark               :string                                 # 报名表备注
#  form                 :jsonb                                  # 报名表单定义
#  execute_state        :integer                                # 执行状态
#

# 活动
class Campaign < ApplicationRecord
  attr_accessor :form_attributes

  belongs_to :project, optional: true
  belongs_to :campaign_category
  has_many :campaign_enlists, dependent: :destroy
  has_many :users, through: :campaign_enlists

  belongs_to :appoint_fund, class_name: 'Fund', optional: true # 定项指定

  validates :name, :start_time, :end_time, :sign_up_start_time, :sign_up_end_time, presence: true

  enum state: {show: 1, hidden: 2} # 状态：1:启用 2:禁用
  default_value_for :state, 1

  enum execute_state: {draft: 0, submit: 1, to_do: 2, doing:3, done: 4} # 执行状态 0:未开始 1:报名中 2:报名完成 3:进行中 4:已结束
  default_value_for :execute_state, 0

  scope :sorted, ->{ order(created_at: :desc) }

  default_value_for :form, []
  default_value_for :number, 0
  before_save :set_form_from_attributes

  attr_accessor :image_id

  include HasAsset
  has_one_asset :image, class_name: 'Asset::CampaignImage'
  has_one_asset :banner, class_name: 'Asset::CampaignBanner'

  # 给form添加一行
  def build_form
    form = self.form || []
    form.push({key: '', label: '', placeholder: '', type: 'text', options: [], required: false})
    self.form = form
  end

  def detail_state_name(user=nil)
    if user && self.campaign_enlists.paid.exists?(user_id: user.id)
      '已报名'
    elsif self.done?
      '活动已结束'
    elsif self.to_do?
      '报名结束'
    elsif self.number.to_i > 0 && self.campaign_enlists.paid.count > self.number
      '名额已满'
    elsif Time.now < self.sign_up_start_time
      '未开始报名'
    else
      '立即报名'
    end
  end

  def summary_builder(user=nil)
    Jbuilder.new do |json|
      json.(self, :id, :name, :price, :start_time, :end_time, :sign_up_end_time)
      json.state_name self.detail_state_name(user)
      json.image_mode self.image.present?
      json.image self.image_url(:tiny).to_s
      json.banner self.banner_url(:tiny)
      json.category self.campaign_category.name
      # json.pay_amount self.campaign_enlists.find_by(user_id: user.id).total if user.present?
    end.attributes!
  end

  def detail_builder(user=nil)
    Jbuilder.new do |json|
      json.merge! self.summary_builder
      json.number self.number.to_i
      json.enlist_count self.campaign_enlists.paid.count
      json.form self.form
      json.content self.content
      json.state_name self.detail_state_name(user)
    end.attributes!
  end

  private
  def set_form_from_attributes
    return unless self.form_attributes.present?
    self.form = self.form_attributes.values.map{|item| item['options'] = item['options'].to_s.split('|') || []; item}
  end
end
