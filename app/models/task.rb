# == Schema Information
#
# Table name: tasks # 任务表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 任务名
#  duration   :integer                                # 时长
#  content    :integer                                # 内容
#  num        :integer                                # 人数
#  state      :integer                                # 状态
#  major_id   :integer                                # 等级
#  province   :integer                                # 省
#  city       :integer                                # 市
#  district   :integer                                # 区
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Task < ApplicationRecord
end
