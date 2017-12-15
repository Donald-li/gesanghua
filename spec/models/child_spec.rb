# == Schema Information
#
# Table name: children # 格桑花孩子表
#
#  id              :integer          not null, primary key
#  idcard          :string                                 # 身份证
#  name            :string                                 # 姓名
#  school_id       :integer                                # 学校ID
#  user_id         :integer                                # 用户ID
#  password_digest :string                                 # 密码
#  gsh_no          :string                                 # 格桑花内部编码
#  state           :integer          default("show")       # 状态：1:启用 2:禁用
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe Child, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
