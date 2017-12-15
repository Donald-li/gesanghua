# == Schema Information
#
# Table name: donate_records # 捐赠记录
#
#  id                  :integer          not null, primary key
#  user_id             :integer                                # 用户id
#  appoint_type        :string                                 # 指定类型
#  appoint_id          :integer                                # 指定类型
#  finance_category_id :integer                                # 类别id
#  pay_state           :integer                                # 状态
#  amount              :decimal(14, 2)   default(0.0)          # 任务id
#  project_id          :integer                                # 项目id
#  project_apply_id    :integer                                # 项目申请id
#  team_id             :integer                                # 小组id
#  message             :string                                 # 汇款信息
#  donor               :string                                 # 捐赠者
#  promoter_id         :integer                                # 劝捐人
#  remitter_name       :string                                 # 汇款人姓名
#  remitter_id         :integer                                # 汇款人id
#  voucher_state       :integer                                # 捐赠收据状态
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

RSpec.describe DonateRecord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
