# == Schema Information
#
# Table name: majors # 专业表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 专业名称
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Major < ApplicationRecord
  has_many :tasks
  has_many :volunteer_major_ships
  has_many :volunteers, through: :volunteer_major_ships

  scope :sorted, ->{ order(created_at: :desc) }

end
