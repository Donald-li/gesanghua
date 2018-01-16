# == Schema Information
#
# Table name: period_child_ships # 年度孩子和申请学期中间表
#
#  id                             :integer          not null, primary key
#  project_season_apply_period_id :integer                                # 申请学期ID
#  project_season_apply_child_id  :integer                                # 年度孩子ID
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#

require 'rails_helper'

RSpec.describe PeriodChildShip, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
