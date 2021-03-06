# == Schema Information
#
# Table name: donations # 捐助表
#
#  id                      :bigint(8)        not null, primary key
#  donor_id                :integer                                # 捐助人id
#  owner_type              :string
#  owner_id                :bigint(8)                              # 捐助所属模型
#  pay_state               :integer                                # 支付状态
#  project_id              :integer                                # 项目id
#  project_season_id       :integer                                # 批次/年度id
#  project_season_apply_id :integer                                # 申请id
#  order_no                :string                                 # 订单编号
#  title                   :string                                 # 标题
#  promoter_id             :integer                                # 劝捐人
#  team_id                 :integer                                # 团队id
#  pay_result              :text                                   # 支付接口返回的支付接口数据
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  details                 :jsonb                                  # 捐助详情
#  amount                  :decimal(14, 2)   default(0.0)          # 捐助金额
#  agent_id                :integer                                # 代理人id
#  pay_way                 :integer                                # 支付方式
#  message                 :text                                   # 留言
#

require 'rails_helper'

RSpec.describe Donation, type: :model do
  before(:all) do
    @donor = create(:user, balance: 0)
    @fund_category = create(:fund_category)
    @fund = create(:fund, fund_category: @fund_category)
    @donate_item = create(:donate_item, fund: @fund)
  end


  describe "测试劝捐和团队捐款" do
    it '有代捐人的捐款' do

    end

    it '有劝捐人' do
    end

    it '有团队的捐款' do
    end

  end

  describe '测试支付成功' do
    it '微信支付成功' do
      result = {"appid"=>"wx771c54fb737861a3", "bank_type"=>"CFT", "cash_fee"=>"1", "fee_type"=>"CNY", "is_subscribe"=>"Y", "mch_id"=>"1386171602", "nonce_str"=>"2e8946e3ec114102b1fd7c9d2be59a06", "openid"=>"o85zvjvpHVJM2YJV5kOe1oYmFoYE", "out_trade_no"=>"180404160000003", "result_code"=>"SUCCESS", "return_code"=>"SUCCESS", "sign"=>"49640DDD5752BB1502EAF831246AB1ED", "time_end"=>"20180404164424", "total_fee"=>"1", "trade_type"=>"JSAPI", "transaction_id"=>"4200000088201804042044369792"}
      donation = Donation.create(amount: result['total_fee'], owner: @donate_item, donor_id: @donor.id, agent_id: @donor.id)
      result['out_trade_no'] = donation.order_no
      Donation.wechat_payment_success result

      expect(donation.income_record).to_not be(nil)
      expect(donation.donate_records.count).to eq 1
      expect(donation.donate_records.first.donor_id).to eq donation.donor_id
      expect(donation.donate_records.first.amount).to eq 1
    end

    it '微信支付成功-批量捐助' do
      result = {"appid"=>"wx771c54fb737861a3", "bank_type"=>"CFT", "cash_fee"=>"1", "fee_type"=>"CNY", "is_subscribe"=>"Y", "mch_id"=>"1386171602", "nonce_str"=>"2e8946e3ec114102b1fd7c9d2be59a06", "openid"=>"o85zvjvpHVJM2YJV5kOe1oYmFoYE", "out_trade_no"=>"180404160000003", "result_code"=>"SUCCESS", "return_code"=>"SUCCESS", "sign"=>"49640DDD5752BB1502EAF831246AB1ED", "time_end"=>"20180404164424", "total_fee"=>"1", "trade_type"=>"JSAPI", "transaction_id"=>"4200000088201804042044369792"}
      donation = Donation.create(amount: result['total_fee'], owner: @donate_item, donor_id: @donor.id, agent_id: @donor.id)
      result['out_trade_no'] = donation.order_no
      Donation.batch_wechat_payment_success result

      expect(donation.income_record).to_not be(nil)
      expect(donation.donate_records.count).to eq 1
      expect(donation.donate_records.first.donor_id).to eq donation.donor_id
      expect(donation.donate_records.first.amount).to eq 1
    end

    it '支付宝支付成功-批量捐助' do
      result = {"order_no"=>"190129100000006", "buyer_email"=>"18363993647@163.com", "buyer_id"=>"2088112067053142", "exterface"=>"create_donate_trade_p", "gmt_payment"=>"2019-01-29 10:56:56", "is_success"=>"T", "notify_id"=>"RqPnCoPT3K9%2Fvwbh3Ihy%2B80Tw%2FvHJZ3aVEB9tH9tdKRlTfH5zxrl%2Fb5NIFImjirToZrj", "notify_time"=>"2019-01-29 10:57:04", "notify_type"=>"trade_status_sync", "out_trade_no"=>"190129100000006", "seller_email"=>"qhgesanghua@gesanghua.org", "seller_id"=>"2088201540829461", "subject"=>"捐助给格桑花", "total_fee"=>"1", "trade_no"=>"2019012922001353141016007721", "trade_status"=>"TRADE_FINISHED", "sign"=>"c059c2fbbbb593ad9348392c3fc6d25b", "sign_type"=>"MD5"}
      donation = Donation.create(amount: result['total_fee'], owner: @donate_item, donor_id: @donor.id, agent_id: @donor.id)
      result['out_trade_no'] = donation.order_no
      Donation.batch_alipay_payment_success result

      expect(donation.income_record).to_not be(nil)
      expect(donation.donate_records.count).to eq 1
      expect(donation.donate_records.first.donor_id).to eq donation.donor_id
      expect(donation.donate_records.first.amount).to eq 1
    end


  end

end
