# == Schema Information
#
# Table name: projects
#
#  id                         :integer          not null, primary key
#  type                       :string                                      # 单表继承字段
#  kind                       :integer                                     # 项目类型 1:固定项目 2:物资类项目
#  name                       :string                                      # 项目名称
#  describe                   :text                                        # 简介
#  protocol                   :text                                        # 用户协议
#  fund_id                    :integer                                     # 关联财务分类id
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  donate_record_amount_count :decimal(14, 2)   default(0.0)               # 累计捐助金额
#  alias                      :string                                      # 项目别名，使用英文
#  appoint_fund_id            :integer                                     # 定向指定财务分类id
#  position                   :integer                                     # 位置排序
#  form                       :jsonb                                       # 自定义表单{key, label, type, options, required}
#  donate_item_id             :integer                                     # 捐助项id
#  accept_feedback_state      :integer                                     # 是否接受定期反馈：1:open_feedback 2:close_feedback
#  feedback_period            :integer                                     # 建议定期反馈次数/年
#  apply_kind                 :integer          default("platform_assign") # 申请类型 1:平台分配 2:用户申请
#

# 项目父表
class Project < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  attr_accessor :image_id, :form_attributes
  attr_accessor :icon_id, :form_attributes
  attr_accessor :head_image_id, :form_attributes

  include HasAsset
  has_one_asset :image, class_name: 'Asset::ProjectImage'
  has_one_asset :head_image, class_name: 'Asset::ProjectHeadImage'
  has_one_asset :icon, class_name: 'Asset::ProjectIcon'

  has_many :seasons, class_name: 'ProjectSeason', dependent: :destroy
  has_many :applies, class_name: 'ProjectSeasonApply', dependent: :destroy
  has_many :children, class_name: 'ProjectSeasonApplyChild', dependent: :destroy
  has_many :bookshelves, class_name: 'ProjectSeasonApplyBookshelf', dependent: :destroy
  has_many :goods, class_name: 'ProjectSeasonApplyGoods', dependent: :destroy
  has_many :volunteer, class_name: 'Volunteer', dependent: :destroy
  has_many :donate_records
  has_many :teacher_projects
  has_many :teachers, through: :teacher_projects
  has_many :project_reports
  has_many :continual_feedbacks, as: :owner
  belongs_to :donate_item, optional: true

  belongs_to :fund, optional: true # 定项非指定
  belongs_to :appoint_fund, class_name: 'Fund', optional: true # 定项指定

  validates :name, :protocol, presence: true

  default_value_for :form, []
  before_save :set_form_from_attributes

  enum kind: { fixed: 1, apply: 2, goods: 3 } # 项目类型 1:固定类 2:申请类 2:物资类
  default_value_for :kind, 2

  enum accept_feedback_state: {close_feedback: 1, open_feedback: 2} # 是否开启定期反馈 1:关闭 2:开启
  default_value_for :accept_feedback_state, 1

  enum apply_kind: { platform_assign: 1, user_apply: 2}
  default_value_for :apply_kind, 1

  scope :sorted, ->{ order(id: :asc) }
  scope :visible, ->{}

  def self.pair_project
    self.find 1
  end

  def self.read_project
    self.find 2
  end

  def self.book_supply_project
    self.find 2
  end

  def self.radio_project
    self.find 6
  end

  def self.care_project
    self.find 7
  end

  def self.movie_project
    self.find 4
  end

  def self.movie_care_project
    self.find 5
  end

  def self.camp_project
    self.find 3
  end

  def sliced_describe
    self.describe.length > 90 ? self.describe.slice(0..90) : self.describe
  end

  # 给form添加一行
  def build_form
    form = self.form || []
    form.push({key: '', label: '', placeholder: '', type: 'text', options: [], required: false})
    self.form = form
  end

  # 根据form的key显示标签
  def form_label(key)
    (self.form || []).detect{|item|item['key'] == key}.try('[]', 'label') || ''
  end

  def form_submit(form)
    self.form.map do |i|
      value = form[i['key']]
      value ||= 0 if i['type'] == 'number'
      [form_label(i['key']), value]
    end
  end

  def project_image
    ActionController::Base.helpers.asset_path(self.image_url(:tiny))
  end

  # 可捐助数量
  def to_donate_num
    if self.id == 1
      GshChild.visible.count
    elsif self.id == 2
      ProjectSeasonApplyBookshelf.raising.count
    elsif self.id == 6
      self.applies.to_delivery.count
    elsif self.id == 7
      self.applies.to_delivery.count
    else
      0
    end
  end

  # 项目单位
  def unit
    if self.id == 1
      '个孩子'
    elsif self.id == 2
      '个书架'
    elsif self.id == 6
      '个项目'
    elsif self.id == 7
      '个项目'
    else
      '个'
    end
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :describe, :alias, :apply_kind)
      json.last_feedback_time self.continual_feedbacks.present? ? self.continual_feedbacks.last.created_at.strftime("%Y-%m-%d %H:%M") : ''
      json.cover_mode self.image.present?
      json.cover_url self.image_url(:tiny).to_s
      json.icon_url self.icon_url(nil)
      json.donate_item self.donate_item.try(:summary_builder)
      json.feedback_period self.feedback_period
    end.attributes!
  end

  def detail_builder
    Jbuilder.new do |json|
      json.merge! summary_builder
      json.head_image_url self.head_image_url(:tiny).to_s
      json.total self.donate_record_amount_count
      json.num self.to_donate_num
      json.unit self.unit
    end.attributes!
  end

  def teacher_project_summary_builder
    Jbuilder.new do |json|
      json.(self, :id)
      json.tit self.name
    end.attributes!
  end

  private
  def set_form_from_attributes
    return unless self.form_attributes.present?
    self.form = self.form_attributes.values.map{|item| item['options'] = item['options'].to_s.split('|') || []; item}
  end

end
