# == Schema Information
#
# Table name: tasks # 任务表
#
#  id               :integer          not null, primary key
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
#  principal_id     :integer                                # 任务负责人
#  task_no          :string                                 # 任务编号
#  ordinary_flag    :boolean          default(FALSE)        # 日常
#  intensive_flag   :boolean          default(FALSE)        # 重点
#  urgency_flag     :boolean          default(FALSE)        # 紧急
#  innovative_flag  :boolean          default(FALSE)        # 创新
#  difficult_flag   :boolean          default(FALSE)        # 难点
#

FactoryBot.define do
  factory :task do
    name { FFaker::NameCN.name }
    duration 6
    content { FFaker::LoremCN.sentences(5) }
    apply_end_at Time.now + 2.day
    start_time Time.now + 3.day
    end_time Time.now + 3.day
    num 12
  end
end
