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
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  finish_time         :datetime                               # 任务完成时间
#  approve_time        :datetime                               # 审核时间
#  user_id             :integer                                # 审核人id
#  source              :string                                 # 获得来源
#  kind                :integer                                # 类型
#  reason              :text                                   # 申请理由
#  state               :integer
#

FactoryBot.define do
  factory :task_volunteer do
    
  end
end
