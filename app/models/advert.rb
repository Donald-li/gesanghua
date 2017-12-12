# == Schema Information
#
# Table name: adverts # 广告表
#
#  id            :integer          not null, primary key
#  kind          :integer                                # 分类
#  title         :string                                 # 标题
#  description   :string                                 # 描述
#  url           :string                                 # 链接
#  views_count   :integer                                # 展示次数
#  kind_position :integer                                # 分类排序
#  state         :integer                                # 状态
#  user_id       :integer                                # 用户id
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Advert < ApplicationRecord
  include BufferCount
  has_buffer_count

  attr_accessor :image_id

  include HasAsset
  has_one_asset :image, class_name: 'Asset::AdvertImage'

  enum kind: {banner: 1}
  enum state: { hidden: 2, show: 1}
  default_value_for :state, 1

  validates :kind, presence: true
  acts_as_list scope: [:kind], column: :kind_position

  scope :sorted, -> { order(kind_position: :asc) }
  scope :visible, -> { where(state: 1) }
end
