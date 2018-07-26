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

require 'rails_helper'

RSpec.describe ProjectSeasonApplyCamp, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
