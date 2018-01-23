# == Schema Information
#
# Table name: project_season_apply_children # 项目执行年度申请的孩子表
#
#  id                      :integer          not null, primary key
#  project_id              :integer                                # 关联项目id
#  project_season_id       :integer                                # 关联项目执行年度id
#  project_season_apply_id :integer                                # 关联项目执行年度申请id
#  gsh_child_id            :integer                                # 关联格桑花孩子表id
#  name                    :string                                 # 孩子姓名
#  province                :string                                 # 省
#  city                    :string                                 # 市
#  district                :string                                 # 区/县
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  phone                   :string                                 # 电话
#  qq                      :string                                 # QQ号码
#  nation                  :integer                                # 民族
#  id_card                 :string                                 # 身份证号码
#  parent_name             :string                                 # 家长姓名
#  description             :text                                   # 描述
#  state                   :integer                                # 状态
#  approve_state           :integer                                # 审核状态
#  age                     :integer                                # 年龄
#  level                   :integer                                # 初中或高中
#  grade                   :integer                                # 年级
#  gender                  :integer                                # 性别
#  school_id               :integer                                # 学校ID
#  semester                :integer                                # 学期
#  kind                    :integer                                # 捐助形式：1对外捐助 2内部认捐
#

FactoryBot.define do
  factory :project_season_apply_child, aliases: [:child] do
    name '李同学'
    province '630000'
    city '630100'
    district '630123'
    id_card '370202198411195417'
    age 13
    level 1
    grade 1
    semester 1
    parent_name '李爹'
    sequence(:phone) { |n| "18888#{n.to_s.rjust(6,'0')}" }
  end
end
