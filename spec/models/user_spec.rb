# == Schema Information
#
# Table name: users # 用户
#
#  id                    :integer          not null, primary key
#  openid                :string                                       # 微信openid
#  name                  :string                                       # 姓名
#  login                 :string                                       # 登录账号
#  password_digest       :string                                       # 密码
#  state                 :integer          default("enable")           # 状态 1:启用 2:禁用
#  team_id               :integer                                      # 团队ID
#  profile               :jsonb                                        # 微信profile
#  gender                :integer                                      # 性别，1：男 2：女
#  balance               :decimal(14, 2)   default(0.0)                # 账户余额
#  phone                 :string                                       # 联系方式
#  email                 :string                                       # 电子邮箱地址
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  nickname              :string                                       # 昵称
#  salutation            :string                                       # 孩子们如何称呼我
#  consignee             :string                                       # 收货人
#  province              :string                                       # 省
#  city                  :string                                       # 市
#  district              :string                                       # 区/县
#  address               :string                                       # 详细地址
#  qq                    :string                                       # qq号
#  id_card               :string                                       # 身份证
#  donate_amount         :decimal(14, 2)   default(0.0)                # 捐助金额
#  online_amount         :decimal(14, 2)   default(0.0)                # 线上捐助金额
#  offline_amount        :decimal(14, 2)   default(0.0)                # 线下捐助金额
#  auth_token            :string                                       # Token
#  manager_id            :integer                                      # 线下用户管理人id
#  roles_mask            :integer                                      # 角色
#  kind                  :integer          default("online_user")      # 用户类型 1:平台用户 2:线上用户 3:线下用户
#  phone_verify          :integer          default("phone_unverified") # 手机认证 1:未认证 2:已认证
#  promoter_amount_count :decimal(14, 2)   default(0.0)                # 累计劝捐额
#  use_nickname          :integer                                      # 使用昵称
#  join_team_time        :datetime                                     # 加入团队时间
#  camp_id               :integer                                      # 探索营id
#  project_ids           :jsonb                                        # 可管理项目（项目管理员）
#  notice_state          :boolean          default(FALSE)              # 用户是否有未查看的公告
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }
  let!(:user1) { create(:user, phone: '18866669999') }
  let!(:promoter) { create(:user) }
  let!(:school) { create(:school, creater: user, contact_phone: '18866669999') }
  let!(:teacher) { create(:teacher, school: school, user: user) }
  let!(:project) { create(:project) }
  let!(:season) { create(:project_season, project: project) }
  let!(:apply) { create(:project_season_apply, project: project, season: season, teacher: teacher, school: school) }
  let!(:child) { create(:project_season_apply_child, project: project, season: season, apply: apply, school: school, semester: 'next_term') }
  let!(:teacher1) { create(:teacher, school: school, phone: '18866669998', kind: 'teacher') }
  let!(:headmaster) { create(:teacher, school: school, phone: '18866669999', kind: 'headmaster') }
  let!(:volunteer) { create(:volunteer, phone: '18866669999') }
  let!(:county_user) { create(:county_user, phone: '18866669999') }
  let!(:user_with_no_phone) { create(:user, phone: nil, balance: 50, donate_amount: 30, offline_amount: 20, online_amount: 10, openid: 'openid', profile: 'profile')}
  let!(:team1) { create(:team, creater: user_with_no_phone, manager: user_with_no_phone)}
  let!(:school1) { create(:school, creater: user_with_no_phone, user: user_with_no_phone) }
  let!(:teacher2) { create(:teacher, school: school, kind: 'teacher', user: user_with_no_phone)}
  let!(:volunteer1) { create(:volunteer, user: user_with_no_phone)}
  let!(:county_user1) { create(:county_user, user: user_with_no_phone)}
  let!(:camp1) { create(:camp, manager: user_with_no_phone)}
  let!(:user2) { create(:user, phone: '18899999999', balance: 0) }
  let!(:offline_user1) { create(:user, manager_id: user2.id, state: 0, balance: 50) }
  let!(:account_record1) { create(:account_record, user: user2, amount: 20)}
  let!(:account_record2) { create(:account_record, user: user2, amount: 30)}
  let!(:income_source1) { create(:income_source, kind: 1)}
  let!(:income_source2) { create(:income_source, kind: 2)}
  let!(:income_record1) { create(:income_record, agent_id: user2.id, donor_id: user_with_no_phone.id, income_source_id: income_source1.id, amount: 10)}
  let!(:income_record2) { create(:income_record, agent_id: user2.id, donor_id: user_with_no_phone.id, income_source_id: income_source2.id, amount: 20)}

  it '测试每日注册用户统计功能' do

    User.update_user_statistic_record

    expect(StatisticRecord.user_register.where(record_time: Time.now.beginning_of_day..Time.now.end_of_day).first.amount).to eq User.count

  end

  it '扣用户余额' do
    user.update(balance: 100)
    User.find(user.id).deduct_balance(50)
    expect(User.find(user.id).balance).to eq 50
    User.find(user.id).deduct_balance(100)
    expect(User.find(user.id).balance).to eq 50
  end

  it '测试绑定用户角色' do
    user1.bind_user_roles
    expect(user1.has_role?(:volunteer)).to eq true
    expect(user1.volunteer.present?).to eq true
    # expect(user1.has_role?(:teacher)).to eq true
    # expect(user1.school.present?).to eq true
    expect(user1.has_role?(:county_user)).to eq true
    expect(user1.county_user.present?).to eq true
  end

  it '测试合并用户' do
    user_with_no_phone.update(team_id: team1.id)
    User.combine_user(user2.phone, user_with_no_phone)
    expect(user_with_no_phone.reload.state).to eq 'disable'
    expect(user2.reload.team_id).to eq team1.id
    expect(team1.reload.creater_id).to eq user2.id
    expect(team1.reload.manage_id).to eq user2.id
    expect(school1.reload.creater_id).to eq user2.id
    expect(school1.reload.user_id).to eq user2.id
    expect(teacher2.reload.user_id).to eq user2.id
    expect(volunteer1.reload.user_id).to eq user2.id
    expect(county_user1.reload.user_id).to eq user2.id
    expect(user2.reload.balance).to eq 50
    expect(user2.reload.donate_amount).to eq 30
    expect(user2.reload.offline_amount).to eq 20
    expect(user2.reload.online_amount).to eq 10
    expect(user2.reload.openid).to eq('openid')
    expect(user2.reload.profile).to eq('profile')
  end

  it '测试迁移捐款记录' do
    user2.migrate_donate_record(user_with_no_phone)
    expect(user2.reload.balance).to eq 50
    expect(user2.reload.donate_amount).to eq 30
    expect(user2.reload.offline_amount).to eq 20
    expect(user2.reload.online_amount).to eq 10
  end

  it '测试代捐人激活' do
    user_with_no_phone.update(team_id: team1.id)
    offline_user1.offline_user_activation(offline_user1.phone, user_with_no_phone)
    expect(user_with_no_phone.reload.state).to eq 'disable'
    expect(offline_user1.reload.team_id).to eq team1.id
    expect(team1.reload.creater_id).to eq offline_user1.id
    expect(team1.reload.manage_id).to eq offline_user1.id
    expect(school1.reload.creater_id).to eq offline_user1.id
    expect(school1.reload.user_id).to eq offline_user1.id
    expect(teacher2.reload.user_id).to eq offline_user1.id
    expect(volunteer1.reload.user_id).to eq offline_user1.id
    expect(county_user1.reload.user_id).to eq offline_user1.id
    expect(offline_user1.reload.balance).to eq 50
    expect(offline_user1.reload.donate_amount).to eq 30
    expect(offline_user1.reload.offline_amount).to eq 20
    expect(offline_user1.reload.online_amount).to eq 10
    expect(offline_user1.reload.openid).to eq('openid')
    expect(offline_user1.reload.profile).to eq('profile')
  end

end
