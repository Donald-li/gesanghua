# == Schema Information
#
# Table name: remarks # 备注信息表
#
#  id            :integer          not null, primary key
#  content       :text                                   # 内容
#  owner_type    :string
#  owner_id      :integer
#  operator_type :string                                 # 操作类型
#  operator_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Remark, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
