# == Schema Information
#
# Table name: specials # 专题表
#
#  id           :integer          not null, primary key
#  name         :string                                 # 专题名
#  template     :integer                                # 模板
#  describe     :text                                   # 简介
#  article_name :string                                 # 资讯名称
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  state        :integer          default("show")       # 状态, 1:展示 2:隐藏
#

class Special < ApplicationRecord
  has_many :special_articles, dependent: :destroy
  has_many :articles, through: :special_articles
  has_many :special_adverts, dependent: :destroy

  validates :name, presence: true

  enum template: {single: 1, double: 2}
  default_value_for :template, 1

  enum state: {show: 1, hidden: 2}
  default_value_for :state, 1

  include HasAsset
  has_one_asset :banner, class_name: 'Asset::SpecialBanner'

  scope :sorted, ->{ order(created_at: :desc) }
end
