# == Schema Information
#
# Table name: volunteer_major_ships
#
#  id           :integer          not null, primary key
#  volunteer_id :integer                                # 志愿者ID
#  major_id     :integer                                # 专业ID
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class VolunteerMajorShip < ApplicationRecord
  belongs_to :volunteer
  belongs_to :major
end
