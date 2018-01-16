# == Schema Information
#
# Table name: vouchers # 捐助收据表
#
#  id            :integer          not null, primary key
#  user_id       :integer                                # 用户ID
#  amount        :decimal(14, 2)   default(0.0)          # 金额
#  state         :integer                                # 状态
#  contact_name  :string                                 # 联系人姓名
#  contact_phone :string                                 # 联系人电话
#  province      :string                                 # 省
#  city          :string                                 # 市
#  district      :string                                 # 区/县
#  address       :string                                 # 详细地址
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  kind          :integer                                # 开票类型
#  tax_no        :string                                 # 开票税号
#  voucher_no    :string                                 # 发票编号
#  tax_company   :string                                 # 开票单位
#

require 'rails_helper'

RSpec.describe Voucher, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
