# == Schema Information
#
# Table name: task_categories # 任务分类
#
#  id         :integer          not null, primary key
#  name       :string                                 # 分类名称
#  describe   :text                                   # 分类描述
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :task_category do
    name {FFaker::NameCN.name}
    describe {FFaker::LoremCN.sentence}
  end
end
