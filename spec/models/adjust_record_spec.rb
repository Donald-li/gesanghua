# == Schema Information
#
# Table name: adjust_records # 分类调整记录
#
#  id           :integer          not null, primary key
#  from_fund_id :integer                                # 从哪个分类
#  to_fund_id   :integer                                # 调到哪个分类
#  amount       :decimal(14, 2)   default(0.0)          # 金额
#  user_id      :integer                                # 操作人
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe AdjustRecord, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
