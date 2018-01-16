# == Schema Information
#
# Table name: project_season_apply_periods # 项目申请时长
#
#  id                :integer          not null, primary key
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
#  grade             :integer                                # 结对对应年级
#  semester          :integer                                # 结对对应学期
#

require 'rails_helper'

RSpec.describe ProjectSeasonApplyPeriod, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
