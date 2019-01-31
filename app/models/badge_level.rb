# == Schema Information
#
# Table name: badge_levels # 勋章级别
#
#  id            :bigint(8)        not null, primary key
#  kind          :integer                                # 类型
#  title         :string                                 # 标题
#  position      :integer                                # 排序
#  value         :integer                                # 获得条件
#  rank          :string                                 # 级别描述
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  default_level :boolean          default(FALSE)        # 默认徽章
#  description   :string                                 # 徽章描述
#

class BadgeLevel < ApplicationRecord
  include HasAsset
  has_one_asset :icon, class_name: 'Asset::BadgeIcon'

  attr_accessor :current_value

  acts_as_list scope: [:kind]
  scope :sorted, -> {order(position: :asc)}

  enum kind: {user_donate: 10, society_team: 20, college_team: 30, ordinary_task: 40, intensive_task: 50, urgency_task: 60, innovative_task: 70, difficult_task: 80, volunteer_age: 90}

  validates :title, :value, :rank, :description, presence: true

  def desc_of_kind
    current_value = self.current_value
    {
        user_donate: "#{current_value}元用户捐款",
        society_team: "#{current_value}元幕款",
        college_team: "#{current_value}元募款",
        ordinary_task: "#{current_value}次普通任务",
        intensive_task: "#{current_value}次重点任务",
        urgency_task: "#{current_value}次紧急任务",
        innovative_task: "#{current_value}次创新任务",
        difficult_task: "#{current_value}次难点任务",
        volunteer_age: "#{current_value}年服务年度"
    }[self.kind.to_sym]
  end

  # 用户或机构的勋章
  def self.level_of_user(owner, kind)
    kind = kind.to_s
    if kind.end_with?('_task')
      value = owner.volunteer && owner.volunteer.task_volunteers.done.joins(:task).where(tasks: {"#{kind.split('_')[0]}_flag": true}).count
      self.level(kind, value.to_i)
    elsif kind == 'user_donate'
      value = owner.donate_amount
      self.level(kind, value.to_i)
    elsif kind == 'volunteer_age'
      value = owner.volunteer.try(:volunteer_age).to_i
      self.level(kind, value.to_i)
    else
      if kind == 'society_team'
        value = owner.team.society? ? owner.team.try(:total_donate_amount) : 0
      else
        value = owner.team.college? ? owner.team.try(:total_donate_amount) : 0
      end
      self.level(kind, value.to_i)
    end

  end

  # 根据kind和值，判断当前等级信息
  def self.level(kind, value)
    level = self.where(kind: kind).order(value: :asc).where("badge_levels.value <= ?", value).last
    level.current_value = value if level.present?
    level
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :rank, :title, :current_value, :default_level)
      json.icon_url self.icon_url(nil)
      json.title self.enum_name(:kind)
      json.describe self.description
    end.attributes!
  end

end
