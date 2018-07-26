# == Schema Information
#
# Table name: partners # 合作伙伴
#
#  id         :bigint(8)        not null, primary key
#  name       :string                                 # 名称
#  url        :string                                 # 链接
#  position   :integer                                # 排序
#  state      :integer                                # 状态： 1:显示 2:隐藏
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Partner < ApplicationRecord

  attr_accessor :image_id

  include HasAsset
  has_one_asset :image, class_name: 'Asset::PartnerImage'

  enum state: {show: 1, hidden: 2}
  default_value_for :state, 1

  acts_as_list column: :position

  scope :sorted, ->{ order(position: :asc) }

end
