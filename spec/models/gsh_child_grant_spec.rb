# == Schema Information
#
# Table name: gsh_child_grants # 格桑花孩子发放表
#
#  id                            :integer          not null, primary key
#  gsh_child_id                  :integer                                # 关联孩子表id
#  project_season_apply_id       :integer                                # 关联申请表
#  state                         :integer                                # 状态 1:为筹款 2:待发放 3:发放完成
#  amount                        :decimal(14, 2)   default(0.0)          # 发放金额
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  school_id                     :integer                                # 学校ID
#  project_season_id             :integer                                # 批次ID
#  donate_state                  :integer                                # 捐助状态
#  grant_no                      :string                                 # 格桑花发放编号
#  granted_at                    :datetime                               # 发放时间
#  grant_remark                  :text                                   # 发放说明
#  delay_reason                  :string                                 # 暂缓发放原因
#  delay_remark                  :text                                   # 暂缓发放备注
#  balance_manage                :integer                                # 取消余额处理
#  cancel_remark                 :text                                   # 取消说明
#  title                         :string                                 # 标题
#  remark                        :text
#  operator_id                   :integer                                # 异常处理人id
#  grant_person                  :string                                 # 发放人
#  user_id                       :integer                                # 捐助人
#  grant_batch_id                :integer                                # 发放批次
#  project_season_apply_child_id :integer                                # 一对一助学孩子id
#  cancel_reason                 :integer                                # 取消原因
#  management_fee_state          :integer                                # 计提管理费状态
#

require 'rails_helper'

RSpec.describe GshChildGrant, type: :model do
  
end
