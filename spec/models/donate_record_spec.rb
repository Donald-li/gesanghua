# == Schema Information
#
# Table name: donate_records # 捐赠记录
#
#  id                            :integer          not null, primary key
#  donor_id                      :integer                                # 用户id
#  fund_id                       :integer                                # 基金ID
#  amount                        :decimal(14, 2)   default(0.0)          # 捐助金额
#  project_id                    :integer                                # 项目id
#  team_id                       :integer                                # 小组id
#  promoter_id                   :integer                                # 劝捐人
#  agent_id                      :integer                                # 汇款人id
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  project_season_id             :integer                                # 年度ID
#  project_season_apply_id       :integer                                # 年度项目ID
#  gsh_child_id                  :integer                                # 格桑花孩子id
#  income_record_id              :integer                                # 收入记录
#  title                         :string                                 # 捐赠标题
#  source_type                   :string
#  source_id                     :integer                                # 资金来源
#  owner_type                    :string
#  owner_id                      :integer                                # 捐助所属捐助项
#  donation_id                   :integer                                # 捐助id
#  kind                          :integer                                # 捐助方式 1:捐款 2:配捐
#  project_season_apply_child_id :integer                                # 一对一孩子
#

require 'rails_helper'

RSpec.describe DonateRecord, type: :model do

  before(:each) do
    @user = create(:user, balance: 0)
    @promoter = create(:user)
    @source = create(:income_source, kind: 1)
    @pair_project = Project.pair_project
    @read_project = Project.read_project
    @radio_project = Project.radio_project
    @pair_season = create(:project_season, project: @pair_project)
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

    @pair_apply = create(:project_season_apply, project: @pair_project, season: @pair_season, school: @school)
    @child1 = create(:project_season_apply_child, project: @pair_project, season: @pair_season, school: @school, apply: @pair_apply)
    @child2 = create(:project_season_apply_child, project: @pair_project, season: @pair_season, school: @school, apply: @pair_apply)
    @child3 = create(:project_season_apply_child, project: @pair_project, season: @pair_season, school: @school, apply: @pair_apply)
    @child4 = create(:project_season_apply_child, project: @pair_project, season: @pair_season, school: @school, apply: @pair_apply)
    @child5 = create(:project_season_apply_child, project: @pair_project, season: @pair_season, school: @school, apply: @pair_apply)
  end

  describe "按捐助类型" do
    it '捐助给捐助项' do
      @income_record.update(amount: 1000, balance: 1000, kind: :online)
      DonateRecord.do_donate(:user_donate, @income_record, @donate_item, 1000)
      expect(@income_record.reload.balance).to eq(0)
      expect(DonateRecord.last.amount).to eq(1000)
    end

    it '捐助给申请' do
      @radio_apply.raise_project! # TODO:
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

    it '捐助给分配申请项（小额零捐情况）' do
      amount = 50
      @read_apply.bookshelves.update_all(state: :raising)
      @income_record.update(amount: amount, balance: amount, kind: :online)
      DonateRecord.do_donate(:user_donate, @income_record, @read_apply, amount)
      expect(@income_record.reload.balance).to eq(0)
      expect(@bookshelf1.reload.present_amount).to eq(50)
      expect(@bookshelf1.reload.surplus_money).to eq(2050)
      expect(@bookshelf3.reload.present_amount).to eq(0)
      expect(@bookshelf5.reload.present_amount).to eq(0)
      expect(@read_apply.reload.present_amount).to eq(50)
      expect(@bookshelf1.state).to eq('raising')
      expect(DonateRecord.last.amount).to eq(50)
      expect(@user.reload.balance).to eq(0)
    end

    it '捐助给分配申请项（孩子）' do
      amount = 2100 * 3 + 100
      GshChildGrant.gen_grant_record(@child1)
      @income_record.update(amount: amount, balance: amount, kind: :online)
      DonateRecord.do_donate(:user_donate, @income_record, @child1, amount)
      expect(@child1.reload.done_semester_count).to eq(3)
      expect(@user.reload.balance).to eq(100)
    end


    it '捐助给分配申请项（孩子）- 捐助金额不足' do
      amount = 1800
      GshChildGrant.gen_grant_record(@child1)
      @income_record.update(amount: amount, balance: amount, kind: :online)
      DonateRecord.do_donate(:user_donate, @income_record, @child1, amount)
      expect(@child1.reload.done_semester_count).to eq(nil)
      expect(@user.reload.balance).to eq(1800)
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
      result, message = DonateRecord.do_donate(:platform_donate, @income_record, @radio_apply, 1000)
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
      result, message = DonateRecord.do_donate(:platform_donate, @fund, @radio_apply, 4000)
      expect(result).to be(false)
    end

    it '超捐' do
      # 使用配捐超捐
      @radio_apply.update(target_amount: 1000, present_amount: 0)
      income_record = create(:income_record, fund: @fund, kind: :offline, amount: 10000, balance: 10000, donor: @user)
      result, message = DonateRecord.do_donate(:platform_donate, income_record, @radio_apply, 10000)
      expect(result).to eq(false)

      expect(income_record.reload.balance).to eq(10000)
      expect(@radio_apply.reload.present_amount).to eq(0)
      expect(@radio_apply.execute_state).to eq('raising')
      expect(@user.reload.balance).to eq(0)
    end
  end


  describe '测试退款' do
    it '退款' do
      amount = 2100
      GshChildGrant.gen_grant_record(@child1)
      @income_record.update(agent: @user,amount: amount, balance: amount, kind: :online)
      DonateRecord.do_donate(:user_donate, @income_record, @child1, amount, agent: @user)
      grant = @child1.gsh_child_grants.first
      expect(grant.donate_state).to eq('succeed')
      expect(grant.state).to eq('waiting')
      donate_record = grant.donate_records.last
      result = donate_record.do_refund!
      expect(result).to be(true)
      expect(donate_record.reload.state).to eq('refund')
      expect(grant.reload.state).to eq('cancel')
      expect(grant.donate_state).to eq('refund')
      expect(@user.reload.balance).to eq(amount)
    end
  end
end
