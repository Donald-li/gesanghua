# == Schema Information
#
# Table name: badge_levels # 勋章级别
#
#  id         :integer          not null, primary key
#  badge_id   :integer                                # 勋章定义
#  title      :string                                 # 标题
#  position   :integer                                # 排序
#  value      :integer                                # 获得条件
#  rank       :string                                 # 级别描述
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe BadgeLevel, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
