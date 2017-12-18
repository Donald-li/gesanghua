# == Schema Information
#
# Table name: pages # 单页面
#
#  id         :integer          not null, primary key
#  title      :string                                 # 标题
#  alias      :string                                 # 别名
#  content    :text                                   # 内容
#  position   :integer                                # 排序
#  state      :integer                                # 状态
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Page < ApplicationRecord

  validates :title, presence: true
  validates :alias, presence: true

  enum state: {show: 1, hidden: 2}
  default_value_for :state, 1

  acts_as_list column: :position
  scope :sorted, ->{ order(position: :asc) }

end
