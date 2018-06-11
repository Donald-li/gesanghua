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
#  amount      :decimal(14, 2)   default(0.0)          # 累计收入
#  in_total    :decimal(14, 2)   default(0.0)          # 历史收入
#  out_total   :decimal(14, 2)   default(0.0)          # 历史支出
#

require 'rails_helper'

RSpec.describe IncomeSource, type: :model do
  
end
