# == Schema Information
#
# Table name: tasks # 任务表
#
#  id               :bigint(8)        not null, primary key
#  name             :string                                 # 任务名
#  duration         :integer                                # 时长
#  content          :text                                   # 内容
#  num              :integer                                # 人数
#  state            :integer                                # 状态
#  major_id         :integer                                # 专业id
#  province         :string                                 # 省
#  city             :string                                 # 市
#  district         :string                                 # 区
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  start_time       :datetime                               # 任务开始时间
#  end_time         :datetime                               # 任务结束时间
#  kind             :integer
#  task_category_id :integer                                # 任务分类ID
#  workplace_id     :integer                                # 工作地点ID
#  apply_end_at     :datetime                               # 申请结束时间
#  task_no          :string                                 # 任务编号
#  ordinary_flag    :boolean          default(FALSE)        # 日常
#  intensive_flag   :boolean          default(FALSE)        # 重点
#  urgency_flag     :boolean          default(FALSE)        # 紧急
#  innovative_flag  :boolean          default(FALSE)        # 创新
#  difficult_flag   :boolean          default(FALSE)        # 难点
#  principal        :string                                 # 任务负责人
#

# 志愿者任务
class Task < ApplicationRecord

  include SanitizeContent
  sanitize_content :content

  before_create :gen_task_no

  # has :major, optional: true
  belongs_to :task_category
  belongs_to :workplace

  has_many :task_volunteers, dependent: :destroy
  has_many :volunteers, through: :task_volunteers

  validates :name, :duration, :content, presence: true

  include HasAsset
  has_one_asset :cover, class_name: 'Asset::TaskCover'

  enum state: {open: 1, close: 2} # 状态 1:开启报名 2:关闭报名
  default_value_for :state, 1

  enum kind: {normal: 1, appoint: 2} # 任务类型： 1:公开任务 2:指定任务
  default_value_for :kind, 1

  scope :sorted, -> {order(created_at: :desc)}

  def simple_address
    ChinaCity.get(self.province).to_s + " " + ChinaCity.get(self.city).to_s + " " + ChinaCity.get(self.district).to_s
  end

  def participant_number
    self.task_volunteers.count
  end

  def gen_task_no
    time_string = Time.now.strftime("%y%m%d")
    self.task_no ||= Sequence.get_seq(kind: :task_no, prefix: time_string, length: 3)
  end

  def formatted_content
    self.content.gsub(/\r\n/, '<br>').gsub(/(<br\/*>\s*){1,}/, '<br>') if self.content.present?
  end

  def summary_builder(user=nil)
    Jbuilder.new do |json|
      json.(self, :id, :name, :num, :duration, :ordinary_flag, :intensive_flag, :urgency_flag, :innovative_flag, :difficult_flag)
      json.location self.workplace.try(:title)
      json.cover_mode self.cover.present?
      json.cover_url self.cover_url(:small)
    end.attributes!
  end

  def detail_builder(user=nil)
    Jbuilder.new do |json|
      json.(self, :id, :name, :num, :duration, :ordinary_flag, :intensive_flag, :urgency_flag, :innovative_flag, :difficult_flag)
      json.location self.workplace.try(:title)
      json.content self.formatted_content
      json.principal self.principal
      json.category self.task_category.try(:name)
      json.start_time self.start_time.strftime("%Y-%m-%d %H:%M")
      json.end_time self.end_time.strftime("%Y-%m-%d %H:%M")
      json.cover_mode self.cover.present?
      json.cover_url self.cover_url(:medium)
      json.can_apply !self.task_volunteers.where(volunteer: user.volunteer).present?
    end.attributes!
  end

  def self.send_messages(user_ids)
    user_ids.each do |id|
      user = User.find(id)
      Notification.create(
          kind: 'new_task',
          owner: user,
          user_id: id,
          title: "#新任务通知# 系统发布了新任务哦",
          content: "系统发布了新一批任务，快去报名参与吧~~",
          url: "#{Settings.m_root_url}/cooperation/tasks"
      )
    end
  end

end
