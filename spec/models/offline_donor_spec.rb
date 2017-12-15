# == Schema Information
#
# Table name: offline_donors # 代捐人表
#
#  id         :integer          not null, primary key
#  user_id    :integer                                # 用户ID
#  name       :string                                 # 姓名
#  state      :integer                                # 状态
#  gender     :integer                                # 性别，1：男 2：女
#  email      :string                                 # 邮箱
#  phone      :string                                 # 联系方式
#  address    :string                                 # 详细地址
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe OfflineDonor, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
