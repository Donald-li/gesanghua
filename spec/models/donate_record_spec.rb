# == Schema Information
#
# Table name: donate_records # 捐赠记录
#
#  id                                :integer          not null, primary key
#  user_id                           :integer                                # 用户id
#  appoint_type                      :string                                 # 指定类型
#  appoint_id                        :integer                                # 指定类型
#  fund_id                           :integer                                # 基金ID
#  pay_state                         :integer                                # 付款状态
#  amount                            :decimal(14, 2)   default(0.0)          # 捐助金额
#  project_id                        :integer                                # 项目id
#  team_id                           :integer                                # 小组id
#  message                           :string                                 # 留言
#  donor                             :string                                 # 捐赠者
#  promoter_id                       :integer                                # 劝捐人
#  remitter_name                     :string                                 # 汇款人姓名
#  remitter_id                       :integer                                # 汇款人id
#  voucher_state                     :integer                                # 捐赠收据状态
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  project_season_id                 :integer                                # 年度ID
#  project_season_apply_id           :integer                                # 年度项目ID
#  project_season_apply_child_id     :integer                                # 年度孩子申请ID
#  donate_no                         :string                                 # 捐赠编号
#  voucher_id                        :integer                                # 捐助记录ID
#  period                            :integer                                # 月捐期数
#  month_donate_id                   :integer                                # 月捐id
#  certificate_no                    :string                                 # 捐赠证书编号
#  gsh_child_id                      :integer                                # 格桑花孩子id
#  kind                              :integer                                # 记录类型: 1:系统生成 2:手动添加
#  project_season_apply_bookshelf_id :integer                                # 书架id
#  bookshelf_supplement_id           :integer                                # 补书ID
#  donate_item_id                    :integer                                # 可捐助id
#  income_record_id                  :integer                                # 收入记录
#  title                             :string                                 # 捐赠标题
#  pay_result                        :string                                 # 支付结果
#

require 'rails_helper'

RSpec.describe DonateRecord, type: :model do

  before(:each) do
    @user = create(:user, balance: 0)
    @promoter = create(:user)
    @source = create(:income_source, kind: 1)
    @read_project = Project.read_project
    @radio_project = Project.radio_project
    @read_season = create(:project_season, project: @read_project)
    @radio_season = create(:project_season, project: @radio_project)
    @school = create(:school, user: @user)
    @fund_category = create(:fund_category)
    @fund = create(:fund, fund_category: @fund_category)
    @donate_item = create(:donate_item, fund: @fund)
    @income_record = create(:income_record, fund: @fund, amount: 1000, balance: 1000, donor: @user)
    @radio_apply = create(:project_season_apply, project: @radio_project, season: @radio_season, school: @school, target_amount: 10000, present_amount: 0)

    @read_apply = create(:project_season_apply, project: @read_project, season: @read_season, school: @school, bookshelf_type: 'whole', target_amount: 10500, present_amount: 0)
    @bookshelf1 = create(:project_season_apply_bookshelf, project: @read_project, season: @read_season, school: @school, apply: @read_apply, target_amount: 2100, present_amount: 0)
    @bookshelf2 = create(:project_season_apply_bookshelf, project: @read_project, season: @read_season, school: @school, apply: @read_apply, target_amount: 2100, present_amount: 0)
    @bookshelf3 = create(:project_season_apply_bookshelf, project: @read_project, season: @read_season, school: @school, apply: @read_apply, target_amount: 2100, present_amount: 0)
    @bookshelf4 = create(:project_season_apply_bookshelf, project: @read_project, season: @read_season, school: @school, apply: @read_apply, target_amount: 2100, present_amount: 0)
    @bookshelf5 = create(:project_season_apply_bookshelf, project: @read_project, season: @read_season, school: @school, apply: @read_apply, target_amount: 2100, present_amount: 0)
  end

  describe "按捐助类型" do
    it '捐助给捐助项' do
      @income_record.update(amount: 1000, balance: 1000, kind: :online)
      DonateRecord.do_donate(:user_donate, @income_record, @donate_item, 1000)
      expect(@income_record.reload.balance).to eq(0)
      expect(DonateRecord.last.amount).to eq(1000)
    end

    it '捐助给申请' do
      @income_record.update(amount: 1000, balance: 1000, kind: :online)
      DonateRecord.do_donate(:user_donate, @income_record, @radio_apply, 1000)
      expect(@income_record.reload.balance).to eq(0)
      expect(@radio_apply.reload.present_amount).to eq(1000)
      expect(DonateRecord.last.amount).to eq(1000)

      # 超捐
      income_record = create(:income_record, fund: @fund, amount: 10000, balance: 10000, donor: @user)
      DonateRecord.do_donate(:user_donate, income_record, @radio_apply, 10000)
      expect(income_record.reload.balance).to eq(0)
      expect(@radio_apply.reload.present_amount).to eq(10000)
      expect(@radio_apply.execute_state).to eq('to_delivery')
      expect(DonateRecord.last.amount).to eq(9000)
      expect(@user.reload.balance).to eq(1000)
    end

    it '捐助给指定申请项' do
      @bookshelf1.update(target_amount: 2100, present_amount: 0)
      @income_record.update(amount: 1000, balance: 2100, kind: :online)
      DonateRecord.do_donate(:user_donate, @income_record, @bookshelf1, 2100)
      expect(@income_record.reload.balance).to eq(0)
      expect(@bookshelf1.reload.present_amount).to eq(2100)
      expect(@bookshelf1.state).to eq('to_delivery')
      expect(DonateRecord.last.amount).to eq(2100)

      # 超捐
      income_record = create(:income_record, fund: @fund, amount: 10000, balance: 10000, donor: @user)
      DonateRecord.do_donate(:user_donate, income_record, @bookshelf2, 10000)
      expect(@bookshelf2.reload.present_amount).to eq(2100)
      expect(income_record.reload.balance).to eq(0)
      expect(@user.reload.balance).to eq(7900)
    end

    it '捐助给分配申请项' do
      amount = 2100 * 5 + 100
      @read_apply.bookshelves.update_all(state: :raising)
      @income_record.update(amount: amount, balance: amount, kind: :online)
      DonateRecord.do_donate(:user_donate, @income_record, @read_apply, amount)
      expect(@income_record.reload.balance).to eq(0)
      expect(@bookshelf1.reload.present_amount).to eq(2100)
      expect(@bookshelf3.reload.present_amount).to eq(2100)
      expect(@bookshelf5.reload.present_amount).to eq(2100)
      expect(@read_apply.reload.present_amount).to eq(2100*5)
      expect(@bookshelf5.state).to eq('to_delivery')
      expect(DonateRecord.last.amount).to eq(2100)
      expect(@user.reload.balance).to eq(100)
    end
  end

  describe "资金来源" do
    it '用户余额' do
      @bookshelf1.update(target_amount: 2100, present_amount: 0, state: :raising)
      @user.update(balance: 4000)
      DonateRecord.do_donate(:user_donate, @user, @bookshelf1, 2100)
      expect(@bookshelf1.reload.present_amount).to eq(2100)
      expect(@bookshelf1.state).to eq('to_delivery')
      expect(DonateRecord.last.amount).to eq(2100)
      expect(@user.reload.balance).to eq(4000 - 2100)
    end

    it '配捐-使用余额' do
      @bookshelf1.update(target_amount: 2100, present_amount: 0, state: :raising)
      @user.update(balance: 4000)
      DonateRecord.do_donate(:platform_donate, @user, @bookshelf1, 2100)
      expect(@bookshelf1.reload.present_amount).to eq(2100)
      expect(@bookshelf1.state).to eq('to_delivery')
      expect(DonateRecord.last.amount).to eq(2100)
      expect(@user.reload.balance).to eq(4000 - 2100)
    end

    it '配捐-使用入账记录' do
      @income_record.update(amount: 1000, balance: 1000, kind: :offline)
      result = DonateRecord.do_donate(:platform_donate, @income_record, @radio_apply, 1000)
      expect(result).to be(true)
      expect(DonateRecord.last.amount).to eq(1000)
      expect(@income_record.reload.balance).to eq(0)
      expect(@radio_apply.reload.present_amount).to eq(1000)
    end

    it '配捐-使用财务分类' do
      @radio_apply.update(target_amount: 10000, present_amount: 0)
      @fund.update(balance: 40000)
      DonateRecord.do_donate(:platform_donate, @fund, @radio_apply, 4000)
      expect(@radio_apply.reload.present_amount).to eq(4000)
      expect(DonateRecord.last.amount).to eq(4000)
      expect(@fund.reload.balance).to eq(40000 - 4000)
    end
  end

  describe "异常情况处理" do
    it '余额不足' do
      @radio_apply.update(target_amount: 10000, present_amount: 0)
      @fund.update(balance: 400)
      result = DonateRecord.do_donate(:platform_donate, @fund, @radio_apply, 4000)
      expect(result).to be(false)
    end

    it '超捐' do
      # 使用配捐超捐
      @radio_apply.update(target_amount: 1000, present_amount: 0)
      income_record = create(:income_record, fund: @fund, kind: :offline, amount: 10000, balance: 10000, donor: @user)
      result = DonateRecord.do_donate(:platform_donate, income_record, @radio_apply, 10000)
      expect(result).to eq(false)

      expect(income_record.reload.balance).to eq(10000)
      expect(@radio_apply.reload.present_amount).to eq(0)
      expect(@radio_apply.execute_state).to eq('raising')
      expect(@user.reload.balance).to eq(0)
    end
  end
end
