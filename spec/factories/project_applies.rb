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
#  describe      :text                                   # 描述、申请要求
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  number        :integer                                # 学生数量
#  name          :string                                 # 申请名称
#

FactoryBot.define do
  factory :project_apply do
    user_id 1
    project_id 1
    state 1
    approve_state 1
    school_id 1
    province "MyString"
    city "MyString"
    district "MyString"
  end
end
