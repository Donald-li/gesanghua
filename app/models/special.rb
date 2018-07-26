# == Schema Information
#
# Table name: specials # 专题表
#
#  id           :bigint(8)        not null, primary key
#  name         :string                                 # 专题名
#  template     :integer                                # 模板
#  describe     :text                                   # 简介
#  article_name :string                                 # 资讯名称
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  state        :integer          default("show")       # 状态, 1:展示 2:隐藏
#  author       :string                                 # 编辑人
#  article_id   :integer                                # 资讯id
#  published_at :datetime                               # 发布时间
#

# 专题
class Special < ApplicationRecord

  belongs_to :list_article, class_name: 'Article', foreign_key: :article_id
  has_many :special_articles, dependent: :destroy
  has_many :articles, through: :special_articles
  has_many :special_adverts, dependent: :destroy
  has_many :adverts, through: :special_adverts

  validates :name, presence: true

  attr_accessor :article_category_id

  enum template: {single: 1, double: 2}
  default_value_for :template, 1

  enum state: {show: 1, hidden: 2}
  default_value_for :state, 1

  include HasAsset
  has_one_asset :banner, class_name: 'Asset::SpecialBanner'

  scope :sorted, ->{ order(published_at: :desc) }
end
