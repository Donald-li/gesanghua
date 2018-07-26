# == Schema Information
#
# Table name: adjust_records # 分类调整记录
#
#  id             :bigint(8)        not null, primary key
#  amount         :decimal(14, 2)   default(0.0)          # 金额
#  user_id        :integer                                # 操作人
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  from_item_id   :integer
#  from_item_type :string
#  to_item_type   :string
#  to_item_id     :integer
#

require 'rails_helper'

RSpec.describe AdjustRecord, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
