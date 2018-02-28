# == Schema Information
#
# Table name: teachers # 老师表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 老师姓名
#  nickname   :string                                 # 老师昵称
#  user_id    :integer                                # 用户ID
#  school_id  :integer                                # 学校ID
#  kind       :integer          default("teacher")    # 老师类型：1:校长 2:老师
#  phone      :string                                 # 老师电话号码
#  state      :integer          default("show")       # 老师状态: 1:启用 2:禁用
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  idcard     :string                                 # 身份证
#  qq         :string                                 # QQ
#  openid     :string                                 # 微信openid
#

# 教师
class Teacher < ApplicationRecord

  require 'custom_validators'

  belongs_to :school
  belongs_to :user, optional: true
  has_many :project_season_applies
  has_many :teacher_projects
  has_many :projects, through: :teacher_projects

  validates :name, :phone, presence: true
  validates :phone, uniqueness: true
  validates :idcard, shenfenzheng_no: true
  validates :qq, qq: true

  enum state: {show: 1, hidden: 2} # 状态：1:启用 2:禁用
  default_value_for :state, 1

  enum kind: { headmaster: 1, teacher: 2 } # 老师类型：1:校长 2:老师

  scope :sorted, ->{ order(created_at: :desc) }

end
