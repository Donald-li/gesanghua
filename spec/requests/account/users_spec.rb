require 'rails_helper'

RSpec.describe "Api::V1::Account::Users", type: :request do

  let!(:login_user) {create(:user, balance: '100')}
  let!(:school) {create(:school)}
  let!(:teacher) {create(:teacher, school: school, user: login_user)}
  let!(:project) { create(:project)}
  let!(:season) {create(:project_season, project: project)}
  let!(:apply) {create(:project_season_apply, project: project, season: season, teacher: teacher)}
  let!(:child) {create(:project_season_apply_child, project: project, season: season, apply: apply, school: school)}
  let!(:record) {create(:donate_record, project: project, season: season, apply: apply, user: login_user, appoint: child, pay_state: 'paid', promoter_id: login_user.id )}

  describe '测试我的' do
    it '获取首页' do
      get api_v1_account_users_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:id]).to eq login_user.id
    end

    it '获取账户详情' do
      get get_user_details_api_v1_account_users_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:id]).to eq login_user.id
    end

    it '修改用户资料' do
      post update_user_api_v1_account_users_path,
           params: {name: '策士', phone: '17888888888', location: [110000, 110100, 110101], use_nickname: ['anonymous']},
           headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(login_user.reload.phone).to eq '17888888888'
    end

    it '获取用户劝捐记录' do
      get get_user_promoter_record_api_v1_account_users_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:promoter_records][0][:id]).to eq record.id
    end

    it '获取用户是否有团队' do
      get has_team_api_v1_account_users_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:hasTeam]).to eq false
    end

    it '获取用户余额' do
      get balance_api_v1_account_users_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data]) == '100'
    end
  end

end
