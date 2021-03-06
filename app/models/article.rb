# == Schema Information
#
# Table name: articles # 资讯表
#
#  id                  :bigint(8)        not null, primary key
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
#  special_kind        :integer                                # 专题类型： 1:文字新闻 2:图片新闻
#

# 资讯
class Article < ApplicationRecord
  belongs_to :article_category, optional: true

  has_one :special
  has_many :special_articles, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  scope :admin_visible, -> {where(kind: [1])}
  scope :visible, -> {where(kind: [1, 4])}
  scope :sorted, ->{ order(published_at: :desc) }
  scope :reverse_sorted, ->{ sorted.reverse_order }

  enum kind: {simple: 1, special: 2, announcement: 3, list: 4}# 类型： 1:普通资讯 2: 专题资讯 3: 公告 4:给专题用于列表展示的资讯
  default_value_for :kind, 1

  enum special_kind: {text_news: 1, image_news: 2}
  default_value_for :special_kind, 1

  enum state: {show: 1, hidden: 2}
  default_value_for :state, 1

  enum recommend: { normal: 1, recommend: 2 } # 推荐 0:正常 1:推荐
  default_value_for :recommend, 1

  default_value_for :published_at, Time.now

  attr_accessor :image_id

  include HasAsset
  has_one_asset :image, class_name: 'Asset::ArticleImage'
  has_many_assets :carousel_images, class_name: 'Asset::ArticleCarouselImage'
end
