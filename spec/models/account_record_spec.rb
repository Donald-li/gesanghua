# == Schema Information
#
# Table name: account_records # 账户记录
#
#  id               :integer          not null, primary key
#  user_id          :integer                                # 用户ID
#  kind             :integer                                # 操作类型
#  income_record_id :integer
#  donate_record_id :integer
#  donor_id         :integer
#  amount           :decimal(14, 2)   default(0.0)          # 金额
#  remark           :text                                   # 备注
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  title            :string                                 # 标题
#  state            :integer                                # 类型
#

require 'rails_helper'

RSpec.describe AccountRecord, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
