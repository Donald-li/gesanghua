# == Schema Information
#
# Table name: goods_project_apply_items # 物资类项目申请条目表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 物品名称
#  number     :integer                                # 物品数量
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe GoodsProjectApplyItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
