# == Schema Information
#
# Table name: tasks # 任务表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 任务名
#  duration   :integer                                # 时长
#  content    :text                                   # 内容
#  num        :integer                                # 人数
#  state      :integer                                # 状态
#  major_id   :integer                                # 专业id
#  province   :string                                 # 省
#  city       :string                                 # 市
#  district   :string                                 # 区
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Task < ApplicationRecord
end
