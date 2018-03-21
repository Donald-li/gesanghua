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

  # 用户或机构的勋章
  def self.level_of_user(owner, kind)
    kind = kind.to_s
    value = 0
    if owner.is_a?(Team)
      value = owner.total_donate_amount
    else
      if kind.end_with?('_task')
        value = owner.volunteer.task_volunteers.done.joins(:task).where(tasks: {"#{kind.split('_')[0]}_flag": true}).count
      elsif kind == 'user_donate'
        value = owner.donate_count
      elsif kind == 'volunteer_age'
        # value = owner.volunteer.volunteer_age
      end
    end

    self.level(kind, value)
  end

  # 根据kind和值，判断当前等级信息
  def self.level(kind, value)
    self.where(kind: kind).order(value: :asc).where('? >= value', value).last
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :rank, :title)
      json.icon_url self.icon_url(nil)
    end.attributes!
  end

end
