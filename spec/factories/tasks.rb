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
#  types_mask       :integer                                # 任务类型
#  apply_end_at     :datetime                               # 申请结束时间
#  principal_id     :integer                                # 任务负责人
#  task_no          :string                                 # 任务编号
#

FactoryBot.define do
  factory :task do
    name { FFaker::NameCN.name }
    duration 6
    content { FFaker::LoremCN.sentences(5) }
  end
end
