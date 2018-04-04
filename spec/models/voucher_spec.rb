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

  before(:each) do
    @user = create(:user)
    @voucher = create(:voucher, user_id: @user.id)
    @donate_record_1 = create(:income_record, donor_id: @user.id)
    @donate_record_2 = create(:income_record, donor_id: @user.id)
    @donate_record_3 = create(:income_record, donor_id: @user.id)
  end

  it "测试提交发票信息是否同步更新捐赠记录" do
    donate_records = []
    donate_records << @donate_record_1
    donate_records << @donate_record_2
    donate_records << @donate_record_3
    ids = donate_records.map{ |i| i.id }
    expect(@voucher.save_voucher(ids)).to eq(true)
    expect(@donate_record_1.reload.voucher_id).to eq(@voucher.id)
    expect(@voucher.voucher_no.present?).to eq true
  end

end
