# == Schema Information
#
# Table name: gsh_child_grants # 格桑花孩子发放表
#
#  id                      :integer          not null, primary key
#  gsh_child_id            :integer                                # 关联孩子表id
#  project_season_apply_id :integer                                # 关联申请表
#  state                   :integer                                # 状态 1:为筹款 2:待发放 3:发放完成
#  amount                  :decimal(14, 2)   default(0.0)          # 发放金额
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'rails_helper'

RSpec.describe GshChildGrant, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
