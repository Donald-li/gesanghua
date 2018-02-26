# == Schema Information
#
# Table name: projects
#
#  id                         :integer          not null, primary key
#  type                       :string                                 # 单表继承字段
#  kind                       :integer                                # 项目类型 1:固定项目 2:物资类项目
#  name                       :string                                 # 项目名称
#  describe                   :text                                   # 简介
#  protocol                   :text                                   # 用户协议
#  fund_id                    :integer                                # 关联财务分类id
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  donate_record_amount_count :decimal(14, 2)   default(0.0)          # 累计捐助金额
#  alias                      :string                                 # 项目别名，使用英文
#  appoint_fund_id            :integer                                # 定向指定财务分类id
#  position                   :integer                                # 位置排序
#  form                       :jsonb                                  # 自定义表单{key, label, type, options, required}
#  donate_item_id             :integer                                # 捐助项id
#

class Project < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  attr_accessor :image_id, :form_attributes

  include HasAsset
  has_one_asset :image, class_name: 'Asset::ProjectImage'

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
  has_many :continuals, as: :owner
  belongs_to :donate_item, optional: true

  belongs_to :fund, optional: true # 定项非指定
  belongs_to :appoint_fund, class_name: 'Fund', optional: true # 定项指定

  validates :name, :protocol, presence: true

  default_value_for :form, []
  before_save :set_form_from_attributes

  enum kind: { fixed: 1, apply: 2, goods: 3 } # 项目类型 1:固定类 2:申请类 2:物资类

  scope :sorted, ->{ order(id: :asc) }

  def self.pair_project
    self.find 1
  end

  def self.book_project
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
    form.push({key: '', label: '', type: 'text', options: [], required: false})
    self.form = form
  end

  # 根据form的key显示标签
  def form_label(key)
    (self.form || []).detect{|item|item['key'] == key}.try('[]', 'label') || ''
  end

  def project_image
    self.image_url(:tiny)
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id)
      json.name self.name
      json.describe self.describe
      # json.total_amount self.fund.amount
      json.cover_url self.image_url(:tiny).to_s
      json.donate_item self.donate_item.try(:summary_builder)
    end.attributes!
  end

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :describe)
      json.total self.donate_record_amount_count
      json.cover_mode self.image.present?
      json.cover_url self.image_url(:tiny).to_s
      json.num self.children.pass.outside.show.length
      json.donate_item self.donate_item.try(:summary_builder)
    end.attributes!
  end

  private
  def set_form_from_attributes
    return unless self.form_attributes.present?
    self.form = self.form_attributes.values.map{|item| item['options'] = item['options'].to_s.split(',') || []; item}
  end

end
