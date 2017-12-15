# == Schema Information
#
# Table name: expenditure_records # 支出记录表
#
#  id                  :integer          not null, primary key
#  finance_category_id :integer                                # 类别id
#  appoint_type        :integer                                # 指定类型
#  appoint_id          :integer                                # 指定类型id
#  administrator_id    :integer                                # 管理员id
#  income_record_id    :integer                                # 入账记录类型id
#  deliver_state       :integer                                # 快递状态
#  kind                :integer                                # 类别
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class ExpenditureRecord < ApplicationRecord
end
