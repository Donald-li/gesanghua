# == Schema Information
#
# Table name: expenditure_records # 支出记录表
#
#  id                    :bigint(8)        not null, primary key
#  fund_id               :integer                                # 基金ID
#  appoint_type          :string                                 # 指定类型
#  appoint_id            :integer                                # 指定类型id
#  administrator_id      :integer                                # 管理员id
#  income_record_id      :integer                                # 入账记录id
#  deliver_state         :integer                                # 发放状态
#  kind                  :integer                                # 类别
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  name                  :string                                 # 支出名称
#  expend_no             :string                                 # 支出编号
#  expended_at           :datetime                               # 支出时间
#  operator              :string                                 # 支出经办人
#  remark                :text                                   # 备注
#  amount                :decimal(14, 2)   default(0.0)          # 支出金额
#  expenditure_ledger_id :integer
#  income_source_id      :integer
#

require 'rails_helper'

RSpec.describe ExpenditureRecord, type: :model do

end
