require 'rails_helper'

RSpec.describe "Api::V1::Account::Teams", type: :request do

  let!(:login_user) {create(:user)}
  let!(:user1) {create(:user)}
  let!(:user2) {create(:user)}
  let!(:team1) { create(:team, creater: login_user, manager: login_user) }
  let!(:team2) { create(:team, creater: login_user, manager: user1) }
  let!(:team3) { create(:team, creater: login_user, manager: user2) }
  let!(:team_user1) { create(:user, team: team1, join_team_time: Time.now) }
  let!(:team_user2) { create(:user, team: team1, join_team_time: Time.now) }
  let!(:team_user3) { create(:user, team: team1, join_team_time: Time.now) }

  describe '测试我的团队' do
    it '获取团队列表' do
      get api_v1_account_teams_path, params: {kind: 'college'}, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '创建团队' do
      post api_v1_account_teams_path, params: {
          team: {name: '我的团队', address: '某街道', describe: '团队介绍'},
          location: ['140000', '140300', '140303'], kind: 'college'},
           headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '获取团队详情' do
      get api_v1_account_team_path(team1), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '获取团队详情' do
      get edit_api_v1_account_team_path(team1), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '修改团队信息' do
      patch api_v1_account_team_path(team1), params: {
          team: {name: '我的团队11111', address: '某街道', describe: '团队介绍'},
          location: ['140000', '140300', '140303'], kind: 'college'}, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '移交团队' do
      post turn_team_api_v1_account_teams_path, params: {id: team1.id, user_id: user1.id}, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '解散团队' do
      get dismiss_api_v1_account_teams_path, params: {id: team1.id}, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '加入团队' do
      post join_team_api_v1_account_teams_path, params: {id: team1.id}, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '退出团队' do
      post exit_team_api_v1_account_teams_path, params: {id: team1.id}, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '获取团队成员' do
      get member_api_v1_account_teams_path, params: {id: team1.id}, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:member].count) == 3
    end

  end

end
