# == Schema Information
#
# Table name: majors # 专业表
#
#  id         :bigint(8)        not null, primary key
#  name       :string                                 # 专业名称
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# 志愿者专业
class Major < ApplicationRecord
  # has_many :tasks
  has_many :volunteer_major_ships, dependent: :destroy
  has_many :volunteers, through: :volunteer_major_ships

  scope :sorted, ->{ order(created_at: :desc) }

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :name)
    end.attributes!
  end

end
