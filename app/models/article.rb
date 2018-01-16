# == Schema Information
#
# Table name: articles # 资讯表
#
#  id                  :integer          not null, primary key
#  title               :string                                 # 标题
#  content             :text                                   # 内容
#  state               :integer          default("show")       # 状态, 1:展示 2:隐藏
#  recommend           :integer          default(NULL)         # 推荐 0:正常 1:推荐
#  article_category_id :integer                                # 资讯分类id
#  published_at        :datetime                               # 发布时间
#  author              :string                                 # 作者
#  source              :string                                 # 来源
#  describe            :text                                   # 摘要
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  kind                :integer                                # 类型
#

class Article < ApplicationRecord
  belongs_to :article_category, optional: true

  has_many :special_articles, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  scope :visible, -> {where(kind: 1)}
  scope :sorted, ->{ order(published_at: :desc) }
  scope :reverse_sorted, ->{ order(published_at: :desc) }

  enum kind: {simple: 1, special: 2}
  default_value_for :kind, 1

  enum state: {show: 1, hidden: 2}
  default_value_for :state, 1

  enum recommend: { normal: 1, recommend: 2 } # 推荐 0:正常 1:推荐
  default_value_for :recommend, 1

  default_value_for :published_at, Time.now

  attr_accessor :image_id

  include HasAsset
  has_one_asset :image, class_name: 'Asset::ArticleImage'
end
