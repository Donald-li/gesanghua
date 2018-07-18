# == Schema Information
#
# Table name: project_season_apply_camp_members
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
#  age                          :integer                                # 年龄
#  kind                         :integer                                # 类型 1学生 2老师
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  phone                        :string                                 # 联系方式（老师角色）
#  classname                    :string                                 # 年级
#  height                       :float                                  # 身高
#  weight                       :float                                  # 体重
#  guardian_id_card             :string                                 # 监护人身份证号
#  guardian_relation            :string                                 # 监护人关系
#  cloth_size                   :string                                 # 服装型号
#  course_type                  :string                                 # 教授课程
#  course_grade                 :string                                 # 教授年级
#  period                       :float                                  # 工作时间
#  position                     :string                                 # 职位
#  train_experience             :text                                   # 训练经历
#  project_experience           :text                                   # 格桑花项目经验
#  honor_experience             :text                                   # 荣誉
#

FactoryBot.define do
  factory :project_season_apply_camp_member do
    name '李同学'
    id_card '370202198411195417'
    age 13
    level 1
    grade 1
  end
end
