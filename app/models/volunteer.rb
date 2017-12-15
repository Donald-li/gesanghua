# == Schema Information
#
# Table name: volunteers # 志愿者表
#
#  id         :integer          not null, primary key
#  level      :integer                                # 等级
#  major_id   :integer                                # 专业id
#  duration   :integer                                # 服务时长
#  user_id    :integer                                # 用户
#  job_state  :integer                                # 任务状态
#  state      :integer                                # 状态
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Volunteer < ApplicationRecord
end
