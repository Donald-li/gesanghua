# == Schema Information
#
# Table name: donate_records # 捐赠记录
#
#  id                                :integer          not null, primary key
#  donor_id                          :integer                                # 用户id
#  fund_id                           :integer                                # 基金ID
#  amount                            :decimal(14, 2)   default(0.0)          # 捐助金额
#  project_id                        :integer                                # 项目id
#  team_id                           :integer                                # 小组id
#  promoter_id                       :integer                                # 劝捐人
#  agent_id                          :integer                                # 汇款人id
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  project_season_id                 :integer                                # 年度ID
#  project_season_apply_id           :integer                                # 年度项目ID
#  project_season_apply_child_id     :integer                                # 年度孩子申请ID
#  gsh_child_id                      :integer                                # 格桑花孩子id
#  project_season_apply_bookshelf_id :integer                                # 书架id
#  donate_item_id                    :integer                                # 可捐助id
#  income_record_id                  :integer                                # 收入记录
#  title                             :string                                 # 捐赠标题
#  source_type                       :string
#  source_id                         :integer                                # 资金来源
#  owner_type                        :string
#  owner_id                          :integer                                # 捐助所属捐助项
#  donation_id                       :integer                                # 捐助id
#  kind                              :integer                                # 捐助方式 1:捐款 2:配捐
#

require 'rails_helper'

RSpec.describe DonateRecord, type: :model do

  before(:all) do
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
      # TODO: 需要判断超捐的情况
    end

    it '捐助给分配申请项' do
    end
  end

  describe "资金来源" do
    it '用户捐款' do

    end

    it '用户余额' do

    end

    it '配捐-使用余额' do

    end

    it '配捐-使用入账记录' do
    end

    it '配捐-使用财务分类' do
    end
  end

  describe "异常情况处理" do
    it '余额不足' do
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
