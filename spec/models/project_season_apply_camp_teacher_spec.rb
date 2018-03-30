# == Schema Information
#
# Table name: project_season_apply_camp_teachers # 探索营老师名单
#
#  id                           :integer          not null, primary key
#  name                         :string                                 # 姓名
#  id_card                      :string                                 # 身份证号
#  nation                       :integer                                # 民族
#  gender                       :integer                                # 性别
#  phone                        :string                                 # 联系方式
#  state                        :integer                                # 状态
#  school_id                    :integer                                # 学校id
#  project_season_apply_camp_id :integer                                # 探索营配额id
#  camp_id                      :integer                                # 探索营id
#  project_season_apply_id      :integer                                # 营立项id
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  age                          :integer                                # 年龄
#

require 'rails_helper'

RSpec.describe ProjectSeasonApplyCampTeacher, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
