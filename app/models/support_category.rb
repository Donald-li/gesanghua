# == Schema Information
#
# Table name: support_categories # 帮助主题分类
#
#  id         :bigint(8)        not null, primary key
#  name       :string                                 # 名称
#  describe   :string                                 # 描述
#  position   :integer                                # 排序
#  state      :integer                                # 状态 1:显示 2:隐藏
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# 帮助分类
class SupportCategory < ApplicationRecord
  has_many :supports, dependent: :destroy

  validates :name, presence: true

  enum state: {show: 1, hidden: 2}
  default_value_for :state, 1

#  scope :sorted, ->{ order(created_at: :desc) }
  acts_as_list column: :position
  scope :sorted, ->{ order(position: :asc) }

end
