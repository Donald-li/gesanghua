# == Schema Information
#
# Table name: task_volunteers # 任务的志愿者表
#
#  id                  :integer          not null, primary key
#  task_id             :integer                                # 任务id
#  volunteer_id        :integer                                # 志愿者id
#  comment             :string                                 # 管理员评论
#  achievement_comment :text                                   # 成果描述
#  duration            :integer                                # 时长
#  approve_state       :integer                                # 审核状态
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryBot.define do
  factory :task_volunteer do
    
  end
end