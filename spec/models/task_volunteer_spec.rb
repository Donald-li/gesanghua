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
#  finish_time         :datetime                               # 任务完成时间
#  approve_time        :datetime                               # 审核时间
#  user_id             :integer                                # 审核人id
#  finish_state        :integer                                # 完成状态1:未完成doing 2:已完成done
#  source              :string                                 # 获得来源
#  kind                :integer                                # 类型
#  reason              :text                                   # 申请理由
#

require 'rails_helper'

RSpec.describe TaskVolunteer, type: :model do
  
end
