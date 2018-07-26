# == Schema Information
#
# Table name: support_categories # 帮助主题分类
#
#  id         :bigint(8)        not null, primary key
#  name       :string                                 # 名称
#  describe   :string                                 # 描述
#  position   :integer                                # 排序
#  state      :integer                                # 状态 1:显示 2:隐藏
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe SupportCategory, type: :model do
  
end
