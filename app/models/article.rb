# == Schema Information
#
# Table name: articles # 资讯表
#
#  id                  :integer          not null, primary key
#  title               :string                                 # 标题
#  content             :text                                   # 内容
#  state               :integer          default("show")       # 状态, 1:展示 2:隐藏
#  recommend           :integer          default("normal")     # 推荐 0:正常 1:推荐
#  article_category_id :integer                                # 资讯分类id
#  published_at        :datetime                               # 发布时间
#  author              :string                                 # 作者
#  source              :string                                 # 来源
#  describe            :text                                   # 摘要
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Article < ApplicationRecord
  belongs_to :article_category, optional: true

  scope :sorted, ->{ order(published_at: :desc) }

  enum state: {show: 1, hidden: 2}
  default_value_for :state, 1
  enum recommend: { normal: 0, recommend: 1 } # 推荐 0:正常 1:推荐

  validates :title, presence: true
  validates :content, presence: true

  default_value_for :published_at, Time.now

  attr_accessor :image_id

  include HasAsset
  has_one_asset :image, class_name: 'Asset::ArticleImage'
end
