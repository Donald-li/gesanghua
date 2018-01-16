# == Schema Information
#
# Table name: income_sources # 收入来源
#
#  id          :integer          not null, primary key
#  name        :string                                 # 名称
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :string                                 # 描述
#  position    :integer                                # 位置
#  kind        :integer                                # 类型： 1:线上（online） 2:线下（offline）
#

require 'rails_helper'

RSpec.describe IncomeSource, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
