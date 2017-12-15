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
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe ProjectApply, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
