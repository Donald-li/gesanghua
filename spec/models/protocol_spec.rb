# == Schema Information
#
# Table name: protocols # 协议
#
#  id         :bigint(8)        not null, primary key
#  kind       :integer                                # 类型
#  title      :string                                 # 标题
#  content    :text                                   # 内容
#  version    :string                                 # 版本
#  project_id :integer                                # 关联项目id
#  state      :integer                                # 状态
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Protocol, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
