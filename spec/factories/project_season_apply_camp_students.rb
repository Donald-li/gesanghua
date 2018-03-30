# == Schema Information
#
# Table name: project_season_apply_camp_students # 探索营学生
#
#  id                           :integer          not null, primary key
#  name                         :string                                 # 姓名
#  id_card                      :string                                 # 身份证号
#  nation                       :integer                                # 民族
#  gender                       :integer                                # 性别
#  school_id                    :integer                                # 学校id
#  project_season_apply_camp_id :integer                                # 探索营配额id
#  camp_id                      :integer                                # 探索营id
#  project_season_apply_id      :integer                                # 营立项id
#  grade                        :integer                                # 年级
#  level                        :integer                                # 初高中
#  teacher_name                 :string                                 # 老师姓名
#  teacher_phone                :string                                 # 老师联系方式
#  guardian_name                :string                                 # 监护人姓名
#  guardian_phone               :string                                 # 监护人联系方式
#  description                  :text                                   # 自我介绍
#  reason                       :string                                 # 推荐理由
#  state                        :integer                                # 状态
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#

FactoryBot.define do
  factory :project_season_apply_camp_student do
    name "MyString"
    id_card "MyString"
    nation 1
    school_id 1
    project_season_apply_camp_id 1
    camp_id 1
    project_season_apply_id 1
    grede 1
    teacher_name "MyString"
    teacher_phone "MyString"
    guardian_name "MyString"
    guardian_phone "MyString"
    description "MyText"
  end
end
