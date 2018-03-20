# == Schema Information
#
# Table name: badge_levels # 勋章级别
#
#  id         :integer          not null, primary key
#  kind       :integer                                # 类型
#  title      :string                                 # 标题
#  position   :integer                                # 排序
#  value      :integer                                # 获得条件
#  rank       :string                                 # 级别描述
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BadgeLevel < ApplicationRecord
  include HasAsset

  has_one_asset :icon, class_name: 'Asset::BadgeIcon'

  acts_as_list scope: [:kind]
  scope :sorted, ->{ order(position: :asc) }

  enum kind: {user_donate: 10, society_team: 20, college_team: 30, ordinary_task: 40, intensive_task: 50, urgency_task: 60, innovative_task: 70, difficult_task: 80, volunteer_age: 90}

  validates :title, :value, :rank, presence: true

end
