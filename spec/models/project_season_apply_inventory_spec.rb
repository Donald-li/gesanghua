# == Schema Information
#
# Table name: project_season_apply_inventories # 筹款项目物资清单
#
#  id                      :bigint(8)        not null, primary key
#  project_season_apply_id :integer                                # 项目id
#  name                    :string                                 # 名称
#  unit                    :decimal(14, 2)   default(0.0)          # 单价（元）
#  number                  :integer                                # 数量
#  state                   :integer                                # 状态
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'rails_helper'

RSpec.describe ProjectSeasonApplyInventory, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
