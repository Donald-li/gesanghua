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
