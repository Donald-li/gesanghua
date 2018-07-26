# == Schema Information
#
# Table name: project_season_apply_gooods # 项目执行年度申请的物品表
#
#  id                      :bigint(8)        not null, primary key
#  project_id              :integer                                # 关联项目id
#  project_season_id       :integer                                # 关联项目执行年度id
#  project_season_apply_id :integer                                # 关联项目执行年度申请id
#  project_season_goods_id :integer                                # 关联项目执行年度物品id
#  num                     :integer                                # 物品申请数量
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'rails_helper'

RSpec.describe ProjectSeasonApplyGoood, type: :model do
  
end
