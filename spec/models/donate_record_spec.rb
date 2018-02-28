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
  let!(:user) { create(:user) }
  let!(:promoter) { create(:user) }
  let!(:school) { create(:school, user: user) }
  let!(:teacher) { create(:teacher, school: school, user: user) }
  let!(:project) { create(:project, fund:Project.pair_project.fund, appoint_fund: Project.pair_project.appoint_fund) }
  let!(:season) { create(:project_season, project: project) }
  let!(:apply) { create(:project_season_apply, project: project, season: season, teacher: teacher, school: school) }
  let!(:child) { create(:project_season_apply_child, project: project, season: season, apply: apply, school: school, semester: 'next_term') }

  it '测试用户捐给格桑花' do
    amount = 100000.01
    DonateRecord.donate_gsh(user, amount)

    donate = DonateRecord.last
    expect(donate.user.id).to eq user.id
    expect(donate.unpay?).to be true
    expect(donate.amount).to eq amount
    expect(donate.promoter).to eq nil
    expect(donate.fund_id).to eq Fund.gsh.id
  end

  it '测试有劝捐人的用户捐给格桑花' do
    amount = 999
    DonateRecord.donate_gsh(user, amount, promoter)

    donate = DonateRecord.last
    expect(donate.user.id).to eq user.id
    expect(donate.unpay?).to be true
    expect(donate.amount).to eq amount
    expect(donate.promoter.id).to eq promoter.id
    expect(donate.fund_id).to eq Fund.gsh.id
  end

  it '测试用户捐给一对一项目' do
    amount = 313213
    project = Project.pair_project
    DonateRecord.donate_project(user, amount, project)

    donate = DonateRecord.last
    expect(donate.user.id).to eq user.id
    expect(donate.project.id).to eq project.id
    expect(donate.unpay?).to be true
    expect(donate.amount).to eq amount
    expect(donate.promoter).to eq nil
    expect(donate.fund_id).to eq project.fund.id
  end

  it '测试有劝捐人的用户捐给一对一项目' do
    amount = 313213
    project = Project.pair_project
    DonateRecord.donate_project(user, amount, project, promoter)

    donate = DonateRecord.last
    expect(donate.user.id).to eq user.id
    expect(donate.project.id).to eq project.id
    expect(donate.unpay?).to be true
    expect(donate.amount).to eq amount
    expect(donate.promoter.id).to eq promoter.id
    expect(donate.fund_id).to eq project.fund.id
  end

  it '测试用户捐一对一的指定' do
    child.approve_pass
    gsh_child = child.gsh_child
    project = Project.pair_project
    DonateRecord.donate_child(user, gsh_child, 2)

    donate = DonateRecord.last
    expect(donate.user.id).to eq user.id
    expect(donate.project.id).to eq project.id
    expect(donate.unpay?).to be true
    expect(donate.amount).to eq donate.gsh_child.semesters.succeed.sum(:amount)
    expect(donate.promoter).to eq nil
    expect(donate.fund_id).to eq project.appoint_fund.id
    expect(donate.gsh_child.id).to eq gsh_child.id
    expect(donate.gsh_child.semesters.succeed.count).to eq 2
  end

  it '测试有劝捐人的用户捐一对一的指定' do
    child.approve_pass
    gsh_child = child.gsh_child
    project = Project.pair_project
    DonateRecord.donate_child(user, gsh_child, 2, promoter)

    donate = DonateRecord.last
    expect(donate.user.id).to eq user.id
    expect(donate.project.id).to eq project.id
    expect(donate.unpay?).to be true
    expect(donate.amount).to eq donate.gsh_child.semesters.succeed.sum(:amount)
    expect(donate.promoter.id).to eq promoter.id
    expect(donate.fund_id).to eq project.appoint_fund.id
    expect(donate.gsh_child.id).to eq gsh_child.id
    expect(donate.gsh_child.semesters.succeed.count).to eq 2
  end

  it '测试用户捐给悦读项目' do
    amount = 313213
    project = Project.book_project
    DonateRecord.donate_project(user, amount, project)

    donate = DonateRecord.last
    expect(donate.user.id).to eq user.id
    expect(donate.project.id).to eq project.id
    expect(donate.unpay?).to be true
    expect(donate.amount).to eq amount
    expect(donate.promoter).to eq nil
    expect(donate.fund_id).to eq project.fund.id
  end

  it '测试有劝捐人的用户捐给悦读项目' do
    amount = 313213
    project = Project.book_project
    DonateRecord.donate_project(user, amount, project, promoter)

    donate = DonateRecord.last
    expect(donate.user.id).to eq user.id
    expect(donate.project.id).to eq project.id
    expect(donate.unpay?).to be true
    expect(donate.amount).to eq amount
    expect(donate.promoter.id).to eq promoter.id
    expect(donate.fund_id).to eq project.fund.id
  end

  describe '测试配捐方法' do

    before(:all) do
      @user = create(:user)
      @source = create(:income_source, kind: 2)
      @project = create(:project)
      @project_season = create(:project_season, project_id: @project.id)
      @school = create(:school, user: @user)
      @fund_category = create(:fund_category)
      @fund = create(:fund, fund_category: @fund_category)
      @project_season_apply = create(:project_season_apply, project_id: @project.id, project_season_id: @project_season.id, school: @school)
      @child = create(:project_season_apply_child, project: @project, season: @project_season, apply: @project_season_apply, school: @school, semester: 'next_term')
      @child.approve_pass
      @book_project = Project.book_project
      @book_season = create(:project_season, project: @book_project)
      @book_apply = create(:project_season_apply, project: @book_project, season: @book_season, school: @school)
      @bookshelf = create(:project_season_apply_bookshelf, project: @book_project, season: @book_season, apply: @book_apply, school: @school, target_amount: 1000)
    end

    it '测试线下配捐给指定申请方法' do
      params = {donate_way: 'offline', source_id: @source.id, offline_user_id: @user.id, amount: 500}
      DonateRecord.platform_donate_apply(params, @project_season_apply)
      expect(@project_season_apply.donate_records.last.amount).to eq 500
    end

    it '测试使用其他资金配捐给指定申请方法(资金余额不足会退回)' do
       @fund.update(amount: 0)
      params = {donate_way: 'match', match_fund_id: @fund.id, amount: 500}
      expect(DonateRecord.platform_donate_apply(params, @project_season_apply)).to eq false
    end

    it '测试使用其他资金配捐给指定申请方法(资金余额充足)' do
      @fund.update(amount: 1000)
      params = {donate_way: 'match', match_fund_id: @fund.id, amount: 500}
      DonateRecord.platform_donate_apply(params, @project_season_apply)
      expect(@project_season_apply.donate_records.last.amount).to eq 500
    end

    it '测试用户余额配捐给指定申请方法(余额不足会退回)' do
      @user.update(balance: 0)
      params = {donate_way: 'balance', balance_id: @user.id, amount: 500}
      expect(DonateRecord.platform_donate_apply(params, @project_season_apply)).to eq false
    end

    it '测试用户余额配捐给指定申请方法(余额充足)' do
      @user.update(balance: 1000)
      params = {donate_way: 'balance', balance_id: @user.id, amount: 500}
      DonateRecord.platform_donate_apply(params, @project_season_apply)
      expect(@project_season_apply.donate_records.last.amount).to eq 500
    end

    it '测试线下配捐给指定孩子方法' do
      params = {donate_way: 'offline', source_id: @source.id, offline_user_id: @user.id, grant_number: 2}
      DonateRecord.platform_donate_child(params, @child)
      expect(@child.gsh_child.gsh_child_grants.first.succeed?).to eq true
      expect(@child.gsh_child.gsh_child_grants.second.succeed?).to eq true
      expect(@child.gsh_child.gsh_child_grants.last.succeed?).to eq false
    end

    it '测试使用其他资金配捐给指定孩子方法(资金不足)' do
      @fund.update(amount: 0)
      params = {donate_way: 'match', match_fund_id: @fund.id, grant_number: 2}
      expect(DonateRecord.platform_donate_child(params, @child)).to eq false
    end

    it '测试使用其他资金给指定孩子方法(资金充足)' do
      @fund.update(amount: 30000)
      params = {donate_way: 'match', match_fund_id: @fund.id, grant_number: 2}
      DonateRecord.platform_donate_child(params, @child)
      expect(@child.gsh_child.gsh_child_grants.first.succeed?).to eq true
      expect(@child.gsh_child.gsh_child_grants.second.succeed?).to eq true
      expect(@child.gsh_child.gsh_child_grants.last.succeed?).to eq false
    end

    it '测试用户余额配捐给指定孩子方法(余额不足)' do
      @user.update(balance: 0)
      params = {donate_way: 'balance', balance_id: @user.id, grant_number: 2}
      expect(DonateRecord.platform_donate_child(params, @child)).to eq false
    end

    it '测试用户余额给指定孩子方法(余额充足)' do
      @user.update(balance: 30000)
      params = {donate_way: 'balance', balance_id: @user.id, grant_number: 2}
      DonateRecord.platform_donate_child(params, @child)
      expect(@child.gsh_child.gsh_child_grants.first.succeed?).to eq true
      expect(@child.gsh_child.gsh_child_grants.second.succeed?).to eq true
      expect(@child.gsh_child.gsh_child_grants.last.succeed?).to eq false
    end

    it '测试线下配捐给指定图书角方法' do
      params = {donate_way: 'offline', source_id: @source.id, offline_user_id: @user.id, amount: 500}
      DonateRecord.platform_donate_bookshelf(params, @bookshelf)
      expect(@bookshelf.donates.last.amount).to eq 500
    end

    it '测试使用其他资金配捐给指定图书角方法(资金不足)' do
      @fund.update(amount: 0)
      params = {donate_way: 'match', match_fund_id: @fund.id, amount: 500}
      expect(DonateRecord.platform_donate_bookshelf(params, @bookshelf)).to eq false
    end

    it '测试使用其他资金给指定图书角方法(资金充足)' do
      @fund.update(amount: 30000)
      params = {donate_way: 'match', match_fund_id: @fund.id, amount: 500}
      DonateRecord.platform_donate_bookshelf(params, @bookshelf)
      expect(@bookshelf.donates.last.amount).to eq 500
    end

    it '测试用户余额配捐给指定图书角方法(余额不足)' do
      @user.update(balance: 0)
      params = {donate_way: 'balance', balance_id: @user.id, amount: 500}
      expect(DonateRecord.platform_donate_bookshelf(params, @bookshelf)).to eq false
    end

    it '测试用户余额给指定图书角方法(余额充足)' do
      @user.update(balance: 30000)
      params = {donate_way: 'balance', balance_id: @user.id, amount: 500}
      DonateRecord.platform_donate_bookshelf(params, @bookshelf)
      expect(@bookshelf.donates.last.amount).to eq 500
    end

  end

  describe '测试捐赠编号和捐赠证书生成方法' do
    before(:each) do
      DonateRecord.donate_gsh(user, 3000)
    end
    it '测试捐赠编号方法' do
      record = DonateRecord.first
      record.pay_and_gen_certificate
      expect(record.paid?).to eq true
      expect(record.certificate_no.present?).to eq true
    end

    it '测试捐赠证书' do
      record = DonateRecord.first
      expect(record.donor_certificate_path).to eq "/images/certificates/#{record.created_at.strftime('%Y%m%d')}/#{record.id}/#{Encryption.md5(record.id.to_s)}.jpg"
    end
  end

end
