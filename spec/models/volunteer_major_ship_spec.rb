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

require 'rails_helper'

RSpec.describe VolunteerMajorShip, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
