require 'rails_helper'

RSpec.describe "Api::V1::Main", type: :request do

  let!(:fund_category) { create(:fund_category, name: '格桑花') }
  let!(:fund) { create(:fund, name: '格桑花非指定', fund_category: fund_category) }
  let!(:login_user) { create(:user) }
  let!(:team) { create(:team, creater: login_user) }
  let!(:team_user) { create(:user, team: team) }
  let!(:banner) { create(:advert) }

  describe '获取滚动Banner' do
    it '获取Banner' do
      get banners_api_v1_main_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data].first[:id]).to eq banner.id
    end
  end

  describe '获取可捐助项目列表' do
    it '获取项目' do
      get contribute_api_v1_main_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data].count).to eq Donation.count
    end
  end

  describe '单次捐助' do
    # it '捐助给格桑花' do
    #   post settlement_api_v1_main_path,
    #        params: {amount: '5000', project: {"name"=>"格桑花", "value"=>"toGsh"},
    #                 donor_name: '好心人', by_team: false, pay_method: 'weixin'},
    #        headers: api_v1_headers(login_user)
    #   api_v1_expect_success
    #   expect(json_body[:data][:record_state]).to eq true
    # end
    #
    # it '捐助给指定项目' do
    #   create(:project)
    #   post settlement_api_v1_main_path,
    #        params: {amount: '5000', project: {"name"=>"一对一", "value"=>"1"},
    #                 donor_name: '好心人', by_team: false, pay_method: 'weixin'},
    #        headers: api_v1_headers(login_user)
    #   api_v1_expect_success
    #   expect(json_body[:data][:record_state]).to eq true
    # end
    
    it '捐助给所选可捐助项目' do
      post settlement_api_v1_main_path,
           params: {amount: '5000', donation_project: {"name"=>"一对一", "value"=>"1"},
                    donor_name: '好心人', by_team: false, pay_method: 'weixin'},
           headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:record_state]).to eq true
    end
  end

  describe '月捐' do
    # it '捐助给格桑花' do
    #   post settlement_api_v1_main_path,
    #        params: {amount: '5000', project: {"name"=>"格桑花", "value"=>"toGsh"},
    #                 period: '3', pay_method: 'weixin'},
    #        headers: api_v1_headers(login_user)
    #   api_v1_expect_success
    #   expect(json_body[:data][:record_state]).to eq true
    # end
    #
    # it '捐助给指定项目' do
    #   create(:project)
    #   post settlement_api_v1_main_path,
    #        params: {amount: '5000', project: {"name"=>"一对一", "value"=>"1"},
    #                 period: '3', pay_method: 'weixin'},
    #        headers: api_v1_headers(login_user)
    #   api_v1_expect_success
    #   expect(json_body[:data][:record_state]).to eq true
    # end

    it '捐助给所选可捐助项目' do
      post settlement_api_v1_main_path,
           params: {amount: '5000', donation_project: {"name"=>"一对一", "value"=>"1"},
                    period: '3', pay_method: 'weixin'},
           headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:record_state]).to eq true
    end
  end
end
