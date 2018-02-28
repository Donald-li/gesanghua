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


# 任务分类
class TaskCategory < ApplicationRecord

  has_many :tasks

  scope :sorted, ->{ order(created_at: :desc) }

end
