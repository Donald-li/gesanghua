# == Schema Information
#
# Table name: project_season_apply_periods # 项目申请时长
#
#  id                :bigint(8)        not null, primary key
#  name              :string                                 # 名称
#  kind              :integer                                # 类型
#  state             :integer                                # 状态
#  desciption        :string                                 # 描述
#  start_at          :datetime                               # 开始时间
#  end_at            :datetime                               # 结束时间
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  project_season_id :integer                                # 年度ID
#  position          :integer                                # 位置
#  grade             :integer                                # 一对一对应年级
#  semester          :integer                                # 一对一对应学期
#

require 'rails_helper'

RSpec.describe ProjectSeasonApplyPeriod, type: :model do
  
end
