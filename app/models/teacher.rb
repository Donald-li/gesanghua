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
#

class Teacher < ApplicationRecord
  belongs_to :school
  belongs_to :user

  validates :name, :phone, presence: true
  validates :phone, uniqueness: true

  enum state: {show: 1, hidden: 2} # 状态：1:启用 2:禁用
  enum kind: { headmaster: 1, teacher: 2 } # 老师类型：1:校长 2:老师

end
