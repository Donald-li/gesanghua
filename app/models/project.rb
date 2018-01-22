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
#

class Project < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  attr_accessor :image_id

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

  belongs_to :fund, optional: true

  validates :name, :protocol, presence: true

  enum kind: { normal: 1, goods: 2 } # 项目类型 1:固定项目 2:物资类项目

  scope :sorted, ->{ order(created_at: :asc) }

  def sliced_describe
    self.describe.length > 90 ? self.describe.slice(0..90) : self.describe
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id)
      json.name self.name
      json.describe self.describe
      # json.total_amount self.fund.amount
      json.cover_url self.image_url(:tiny).to_s
    end.attributes!
  end

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :describe)
      json.total number_to_currency(self.donate_record_amount_count)
      json.cover_mode self.image.present?
      json.cover_url self.image_url(:tiny).to_s
    end.attributes!
  end

  def self.find_project(value)
    if value == 'toPair'
      self.find 1
    elsif value == 'toRead'
      self.find 2
    elsif value == 'toBroadcast'
      self.find 5
    elsif value == 'toFlower'
      self.find 6
    elsif value == 'toCamp'
      self.find 4
    else
      ''
    end
  end

end
