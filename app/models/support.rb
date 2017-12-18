# == Schema Information
#
# Table name: supports # 帮助中心主题
#
#  id                  :integer          not null, primary key
#  title               :string                                 # 标题
#  alias               :string                                 # 别名
#  content             :text                                   # 内容
#  position            :integer                                # 排序
#  state               :integer                                # 状态
#  support_category_id :integer                                # 帮助中心分类id
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Support < ApplicationRecord
  # belongs_to :support_category

  validates :title, presence: true
  validates :alias, presence: true

  acts_as_list column: :position
  scope :sorted, ->{ order(position: :asc) }

  enum state: {show: 1, hidden: 2}
  default_value_for :state, 1

  attr_accessor :image_id

  include HasAsset
  has_one_asset :image, class_name: 'Asset::SupportImage'
end
