# == Schema Information
#
# Table name: users # 用户
#
#  id              :integer          not null, primary key
#  openid          :string                                       # 微信openid
#  name            :string                                       # 姓名
#  login           :string                                       # 登录账号
#  password_digest :string                                       # 密码
#  state           :integer          default("enable")           # 状态 1:启用 2:禁用
#  team_id         :integer                                      # 团队ID
#  profile         :jsonb                                        # 微信profile
#  gender          :integer                                      # 性别，1：男 2：女
#  balance         :decimal(14, 2)   default(0.0)                # 账户余额
#  phone           :string                                       # 联系方式
#  email           :string                                       # 电子邮箱地址
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  nickname        :string                                       # 昵称
#  salutation      :string                                       # 孩子们如何称呼我
#  consignee       :string                                       # 收货人
#  province        :string                                       # 省
#  city            :string                                       # 市
#  district        :string                                       # 区/县
#  address         :string                                       # 详细地址
#  qq              :string                                       # qq号
#  idcard          :string                                       # 身份证
#  donate_count    :decimal(14, 2)   default(0.0)                # 捐助金额
#  online_count    :decimal(14, 2)   default(0.0)                # 线上捐助金额
#  offline_count   :decimal(14, 2)   default(0.0)                # 线下捐助金额
#  auth_token      :string                                       # Token
#  manager_id      :integer                                      # 线下用户管理人id
#  roles_mask      :integer                                      # 角色
#  kind            :integer          default("online_user")      # 用户类型 1:平台用户 2:线上用户 3:线下用户
#  phone_verify    :integer          default("phone_unverified") # 手机认证 1:未认证 2:已认证
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }
  let!(:promoter) { create(:user) }
  let!(:school) { create(:school, user: user) }
  let!(:teacher) { create(:teacher, school: school, user: user) }
  let!(:project) { create(:project) }
  let!(:season) { create(:project_season, project: project) }
  let!(:apply) { create(:project_season_apply, project: project, season: season, teacher: teacher, school: school) }
  let!(:child) { create(:project_season_apply_child, project: project, season: season, apply: apply, school: school, semester: 'next_term') }

  it '测试每日注册用户统计功能' do

    User.update_user_statistic_record

    expect(StatisticRecord.user_register.where(record_time: Time.now.beginning_of_day..Time.now.end_of_day).first.amount).to eq User.count

  end

  it '测试管理代捐人' do
    # 新增代捐人
    agent_user1 = user.offline_users.create_offline_user('高', '13500000001', 'male', '叔叔', 'gao@163.com', '630000', '630100', '630123', '某街道')
    agent_user2 = user.offline_users.create_offline_user('高', '13500000002', 'male', '叔叔', '134@163.com', '630000', '630100', '630123', '某街道')

    expect(user.offline_users.count).to eq 2

    # 插入1条手机号已存在的记录
    agent_user3 = user.offline_users.create_offline_user('高', '13500000002', 'male', '叔叔', '134@163.com', '630000', '630100', '630123', '某街道')
    expect(user.offline_users.count).to eq 2

  end

  it '测试用户捐给格桑花' do
    amount = 100000.01
    user.donate_gsh(amount)

    donate = DonateRecord.last
    expect(donate.user.id).to eq user.id
    expect(donate.unpay?).to be true
    expect(donate.amount).to eq amount
    expect(donate.promoter).to eq nil
    expect(donate.fund_id).to eq Fund.gsh.id
  end

  it '测试有劝捐人的用户捐给格桑花' do
    amount = 999
    user.donate_gsh(amount, promoter)

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
    user.donate_project(amount, project)

    donate = DonateRecord.last
    expect(donate.user.id).to eq user.id
    expect(donate.project.id).to eq project.id
    expect(donate.unpay?).to be true
    expect(donate.amount).to eq amount
    expect(donate.promoter).to eq nil
    expect(donate.fund_id).to eq project.fund.id
  end

  it '测试用户捐给悦读项目' do
    amount = 313213
    project = Project.book_project
    user.donate_project(amount, project)

    donate = DonateRecord.last
    expect(donate.user.id).to eq user.id
    expect(donate.project.id).to eq project.id
    expect(donate.unpay?).to be true
    expect(donate.amount).to eq amount
    expect(donate.promoter).to eq nil
    expect(donate.fund_id).to eq project.fund.id
  end

  it '测试用户捐一对一的指定' do
    child.approve_pass
    gsh_child = child
    project = Project.pair_project
    user.donate_child(gsh_child, 2)

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

  it '测试悦读项目整捐' do
    project = Project.book_project
    season = create(:project_season, project: project)
    apply = create(:project_season_apply, project: project, season: season, teacher: teacher, school: school)
    bookshelf = create(:project_season_apply_bookshelf, project: project, season: season, apply: apply, school: school, target_amount: 1000)

    user.donate_bookshelf(bookshelf)
    donate = DonateRecord.last
    expect(donate.user.id).to eq user.id
    expect(donate.project.id).to eq project.id
    expect(donate.unpay?).to be true
    expect(donate.amount).to eq bookshelf.target_amount
    expect(donate.promoter).to eq nil
    expect(donate.fund_id).to eq project.appoint_fund.id
    expect(donate.bookshelf.id).to eq bookshelf.id
    expect(donate.bookshelf.complete?).to be true
  end
end
