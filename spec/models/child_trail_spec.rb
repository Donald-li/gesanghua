# == Schema Information
#
# Table name: child_trails # 孩子轨迹表
#
#  id            :integer          not null, primary key
#  kind          :integer                                # 分类，1：奖项 2：毕业 3：工作
#  content       :text                                   # 详情
#  awarding_body :string                                 # 操作单位
#  awarding_at   :datetime                               # 操作时间
#  child_id      :integer                                # 孩子ID
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe ChildTrail, type: :model do
  
end
