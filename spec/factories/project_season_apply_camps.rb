# == Schema Information
#
# Table name: project_season_apply_camps # 探索营配额
#
#  id                      :bigint(8)        not null, primary key
#  project_season_apply_id :integer                                # 营立项id
#  camp_id                 :integer                                # 探索营id
#  school_id               :integer                                # 学校id
#  describe                :text                                   # 申请要求
#  student_number          :integer                                # 学生数量
#  teacher_number          :integer                                # 陪同老师数量
#  end_time                :datetime                               # 申请截止时间
#  time_limit              :integer                                # 是否设置截止时间
#  message_type            :integer                                # 通知方式
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  execute_state           :integer
#  contact_name            :string
#  contact_phone           :string
#

FactoryBot.define do
  factory :project_season_apply_camp do
    project_season_apply_id 1
    camp_id 1
    school_id 1
    student_number 1
    teacher_number 1
    end_time "2018-03-30 14:12:45"
    describe {FFaker::LoremCN.sentence(10)}
    time_limit 1
    message_type 1
  end
end
