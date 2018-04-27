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

end
