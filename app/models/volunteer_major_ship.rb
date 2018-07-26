# == Schema Information
#
# Table name: volunteer_major_ships
#
#  id           :bigint(8)        not null, primary key
#  volunteer_id :integer                                # 志愿者ID
#  major_id     :integer                                # 专业ID
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

# 志愿者专业关系表
class VolunteerMajorShip < ApplicationRecord
  belongs_to :volunteer
  belongs_to :major
end
