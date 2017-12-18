# == Schema Information
#
# Table name: expenditure_records # 支出记录表
#
#  id                  :integer          not null, primary key
#  finance_category_id :integer                                # 财务分类id
#  appoint_type        :string                                 # 指定类型
#  appoint_id          :integer                                # 指定类型id
#  administrator_id    :integer                                # 管理员id
#  income_record_id    :integer                                # 入账记录id
#  deliver_state       :integer                                # 发放状态
#  kind                :integer                                # 类别
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class ExpenditureRecord < ApplicationRecord
  belongs_to :finance_category
  belongs_to :administrator
  belongs_to :income_record
  # appoint_type 多态关联
  # belongs_to :user, polymorphic: true

  enum deliver_state: {to_deliver: 1, deliver: 2} # 发放状态，1:待发放 2:已发放
  # enum kind: {}

end
