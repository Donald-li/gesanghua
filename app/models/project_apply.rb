# == Schema Information
#
# Table name: project_applies # 项目申请表
#
#  id            :integer          not null, primary key
#  user_id       :integer                                # 用户ID
#  project_id    :integer                                # 项目ID
#  state         :integer          default("show")       # 状态：1:展示 2:隐藏
#  approve_state :integer          default("submit")     # 申请状态：1:待审核 2:审核通过 3:审核不通过
#  school_id     :integer                                # 学校ID
#  province      :string                                 # 省
#  city          :string                                 # 市
#  district      :string                                 # 区/县
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class ProjectApply < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :school

  has_many :bookshelves
  has_many :project_apply_children
  has_many :child_grants
  has_many :donate_records

  validates :province, :city, :distirct, presence: true

  enum state: {show: 1, hidden: 2} # 状态：1:启用 2:禁用
  enum approve_state: { submit: 1, pass: 2, reject: 3 } # 审核状态：1:审核中 2:申请通过 3:申请不通过

  scope :sorted, ->{ order(created_at: :desc) }
end
