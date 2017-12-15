# == Schema Information
#
# Table name: goods_categories # 物资分类
#
#  id         :integer          not null, primary key
#  name       :string                                 # 名称
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe GoodsCategory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
