# == Schema Information
#
# Table name: bookshelves # 书架表
#
#  id               :integer          not null, primary key
#  title            :string                                 # 名称
#  school_id        :integer                                # 学校id
#  class_name       :string                                 # 班级名
#  state            :integer                                # 状态
#  balance          :decimal(14, 2)   default(0.0)          # 剩余金额
#  project_apply_id :integer                                # 项目申请id
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Bookshelf < ApplicationRecord
  belongs_to :school
  belongs_to :project_apply

  validates :title, :class_name, :balance, presence: true

  enum state: {show: 1, hidden: 2} # 状态：1:公开受捐 2:隐藏
  default_value_for :state, 2

end
