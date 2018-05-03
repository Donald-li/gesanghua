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
#  task_no          :string                                 # 任务编号
#  ordinary_flag    :boolean          default(FALSE)        # 日常
#  intensive_flag   :boolean          default(FALSE)        # 重点
#  urgency_flag     :boolean          default(FALSE)        # 紧急
#  innovative_flag  :boolean          default(FALSE)        # 创新
#  difficult_flag   :boolean          default(FALSE)        # 难点
#  principal        :string                                 # 任务负责人
#

require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }
  let(:task_category) { create(:task_category) }
  let(:workplace) { create(:workplace) }
  let(:task) { create(:task, principal: user, task_category: task_category, workplace: workplace) }

  describe '测试生成任务编号' do
    it '生成任务编号' do
      expect(task.task_no.present?).to eq true
    end
  end
end
