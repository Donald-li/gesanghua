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
    project = Project.pair_project
    DonateRecord.donate_child(user: user , child: child, semester_num: 2)

    donate = DonateRecord.last
    expect(donate.user.id).to eq user.id
    expect(donate.project.id).to eq project.id
    expect(donate.unpay?).to be true
    expect(donate.amount).to eq donate.child.semesters.succeed.sum(:amount)
    expect(donate.promoter).to eq nil
    expect(donate.fund_id).to eq project.appoint_fund.id
    expect(donate.child.id).to eq child.id
    expect(donate.child.semesters.succeed.count).to eq 2
  end

  it '测试有劝捐人的用户捐一对一的指定' do
    child.approve_pass
    project = Project.pair_project
    DonateRecord.donate_child(user: user, child: child, semester_num: 2, promoter: promoter)

    donate = DonateRecord.last
    expect(donate.user.id).to eq user.id
    expect(donate.project.id).to eq project.id
    expect(donate.unpay?).to be true
    expect(donate.amount).to eq donate.child.semesters.succeed.sum(:amount)
    expect(donate.promoter.id).to eq promoter.id
    expect(donate.fund_id).to eq project.appoint_fund.id
    expect(donate.child.id).to eq child.id
    expect(donate.child.semesters.succeed.count).to eq 2
  end

  it '测试用户捐给悦读项目' do
    amount = 313213
    project = Project.read_project
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
    project = Project.read_project
    DonateRecord.donate_project(user, amount, project, promoter)

    donate = DonateRecord.last
    expect(donate.user.id).to eq user.id
    expect(donate.project.id).to eq project.id
    expect(donate.unpay?).to be true
    expect(donate.amount).to eq amount
    expect(donate.promoter.id).to eq promoter.id
    expect(donate.fund_id).to eq project.fund.id
  end

  describe '测试用户捐助申请' do
    before(:all) do
      @user = create(:user)
      @promoter = create(:user)
      @source = create(:income_source, kind: 1)
      @project = Project.read_project
      @read_season = create(:project_season, project: @project)
      @school = create(:school, user: @user)
      @fund_category = create(:fund_category)
      @fund = create(:fund, fund_category: @fund_category)
      @read_apply = create(:project_season_apply, project: @project, season: @read_season, school: @school, bookshelf_type: 'whole', target_amount: 10500, present_amount: 0)
      @bookshelf1 = create(:project_season_apply_bookshelf, project: @project, season: @read_season, school: @school, apply: @read_apply, target_amount: 2100, present_amount: 0)
      @bookshelf2 = create(:project_season_apply_bookshelf, project: @project, season: @read_season, school: @school, apply: @read_apply, target_amount: 2100, present_amount: 0)
      @bookshelf3 = create(:project_season_apply_bookshelf, project: @project, season: @read_season, school: @school, apply: @read_apply, target_amount: 2100, present_amount: 0)
      @bookshelf4 = create(:project_season_apply_bookshelf, project: @project, season: @read_season, school: @school, apply: @read_apply, target_amount: 2100, present_amount: 0)
      @bookshelf5 = create(:project_season_apply_bookshelf, project: @project, season: @read_season, school: @school, apply: @read_apply, target_amount: 2100, present_amount: 0)
    end

    it '测试捐助悦读申请' do
      params = { apply_id: @read_apply.id, amount: 2100 }
      donate_record = DonateRecord.donate_apply(user: @user, amount: params[:amount].to_f, apply: @read_apply, promoter: @promoter)
      IncomeRecord.wechat_payment({ "out_trade_no" => donate_record.donate_no, "total_fee" => donate_record.amount.to_f }, params)
      expect(ProjectSeasonApplyBookshelf.count).to eq 5
      expect(ProjectSeasonApplyBookshelf.to_delivery.count).to eq 1
    end

    it '测试悦读零捐超过一个书架金额' do
      params = { apply_id: @read_apply.id, amount: 5000 }
      donate_record = DonateRecord.donate_apply(user: @user, amount: params[:amount].to_f, apply: @read_apply, promoter: @promoter)
      IncomeRecord.wechat_payment({ "out_trade_no" => donate_record.donate_no, "total_fee" => donate_record.amount.to_f }, params)
      expect(ProjectSeasonApplyBookshelf.count).to eq 5
      expect(ProjectSeasonApplyBookshelf.to_delivery.count).to eq 2
      expect(ProjectSeasonApplyBookshelf.raising.count).to eq 3
      expect(ProjectSeasonApplyBookshelf.find(3).present_amount).to eq 800.0
    end

    it '测试捐款金额超过申请目标筹款额' do
      user_balance = @user.balance
      params = { apply_id: @read_apply.id, amount: 20000 }
      donate_record = DonateRecord.donate_apply(user: @user, amount: params[:amount].to_f, apply: @read_apply, promoter: @promoter)
      IncomeRecord.wechat_payment({ "out_trade_no" => donate_record.donate_no, "total_fee" => donate_record.amount.to_f }, params)
      expect(ProjectSeasonApplyBookshelf.count).to eq 5
      expect(ProjectSeasonApplyBookshelf.to_delivery.count).to eq 5
      expect(@user.reload.balance).to eq 9500.0 + user_balance
      # expect(@read_apply.reload.present_amount).to eq @read_apply.target_amount
    end
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
      @income_record = create(:income_record, amount: 5000, balance: 5000, fund: @fund)
      @project_season_apply = create(:project_season_apply, project_id: @project.id, project_season_id: @project_season.id, school: @school)
      @child = create(:project_season_apply_child, project: @project, season: @project_season, apply: @project_season_apply, school: @school, semester: 'next_term')
      @child.approve_pass
      @read_project = Project.read_project
      @book_season = create(:project_season, project: @read_project)
      @book_apply = create(:project_season_apply, project: @read_project, season: @book_season, school: @school)
      @bookshelf = create(:project_season_apply_bookshelf, project: @read_project, season: @book_season, apply: @book_apply, school: @school, target_amount: 1000, present_amount: 0)
    end

    it '测试线下配捐给指定申请方法' do
      params = {donate_way: 'offline', source_id: @source.id, offline_record_id: @income_record.id, amount: 500}
      DonateRecord.platform_donate_apply(params, @project_season_apply)
      expect(@project_season_apply.donate_records.last.amount).to eq 500
      expect(@project_season_apply.donate_records.last.income_record_id).to eq(@income_record.id)
      expect(@income_record.reload.balance).to eq 5000
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
      params = {donate_way: 'offline', source_id: @source.id, offline_record_id: @income_record.id, grant_number: 2}
      DonateRecord.platform_donate_child(params, @child)
      expect(@child.gsh_child_grants.first.succeed?).to eq true
      expect(@child.gsh_child_grants.second.succeed?).to eq true
      expect(@child.gsh_child_grants.last.succeed?).to eq false
      expect(DonateRecord.last.amount).to eq 3150
      expect(DonateRecord.last.income_record_id).to eq(@income_record.id)
      expect(@income_record.reload.balance).to eq 1850
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
      expect(@child.gsh_child_grants.first.succeed?).to eq true
      expect(@child.gsh_child_grants.second.succeed?).to eq true
      expect(@child.gsh_child_grants.last.succeed?).to eq false
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
      expect(@child.gsh_child_grants.first.succeed?).to eq true
      expect(@child.gsh_child_grants.second.succeed?).to eq true
      expect(@child.gsh_child_grants.last.succeed?).to eq false
    end

    it '测试线下配捐给指定图书角方法' do
      params = {donate_way: 'offline', source_id: @source.id, offline_record_id: @income_record.id}
      DonateRecord.platform_donate_bookshelf(params, @bookshelf)
      expect(@bookshelf.donates.last.amount).to eq 1000
    end

    it '测试使用其他资金配捐给指定图书角方法(资金不足)' do
      @bookshelf.update(present_amount: 0)
      @fund.update(amount: 0)
      params = {donate_way: 'match', match_fund_id: @fund.id}
      expect(DonateRecord.platform_donate_bookshelf(params, @bookshelf)).to eq false
    end

    it '测试使用其他资金给指定图书角方法(资金充足)' do
      @bookshelf.update(present_amount: 0)
      @fund.update(amount: 30000)
      params = {donate_way: 'match', match_fund_id: @fund.id}
      DonateRecord.platform_donate_bookshelf(params, @bookshelf)
      expect(@bookshelf.donates.last.amount).to eq 1000
    end

    it '测试用户余额配捐给指定图书角方法(余额不足)' do
      @bookshelf.update(present_amount: 0)
      @user.update(balance: 0)
      params = {donate_way: 'balance', balance_id: @user.id}
      expect(DonateRecord.platform_donate_bookshelf(params, @bookshelf)).to eq false
    end

    it '测试用户余额给指定图书角方法(余额充足)' do
      @bookshelf.update(present_amount: 0)
      @user.update(balance: 30000)
      params = {donate_way: 'balance', balance_id: @user.id}
      DonateRecord.platform_donate_bookshelf(params, @bookshelf)
      expect(@bookshelf.donates.last.amount).to eq 1000
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
