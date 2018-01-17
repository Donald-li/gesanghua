# == Schema Information
#
# Table name: project_season_goods # 物资类项目，执行年度的物品表
#
#  id                :integer          not null, primary key
#  project_id        :integer                                # 关联项目id
#  project_season_id :integer                                # 关联执行年度id
#  name              :string                                 # 物品名称
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe ProjectSeasonGoods, type: :model do
  
end
