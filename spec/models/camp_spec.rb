# == Schema Information
#
# Table name: camps # 探索营
#
#  id         :integer          not null, primary key
#  name       :string                                 # 名称
#  province   :string                                 # 省
#  city       :string                                 # 市
#  district   :string                                 # 区、县
#  fund_id    :integer                                # 资金id
#  manager_id :integer                                # 负责人id
#  state      :integer                                # 状态：1:启用 2:禁用）
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Camp, type: :model do
end
