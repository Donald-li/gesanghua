# == Schema Information
#
# Table name: specials # 专题表
#
#  id           :integer          not null, primary key
#  name         :string                                 # 专题名
#  template     :string                                 # 模板
#  describe     :string                                 # 简介
#  article_name :string                                 # 资讯名称
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Special < ApplicationRecord
  has_many :special_articles

  validates :name, presence: true

  enum template: {yin: 1, yang: 2}
  default_value_for :template, 1

  include HasAsset
  has_one_asset :banner, class_name: 'SpecialBanner'

  scope :sorted, ->{ order(created_at: :desc) }
end
