# == Schema Information
#
# Table name: partners # 合作伙伴
#
#  id         :bigint(8)        not null, primary key
#  name       :string                                 # 名称
#  url        :string                                 # 链接
#  position   :integer                                # 排序
#  state      :integer                                # 状态： 1:显示 2:隐藏
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Partner, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
