require 'rails_helper'

RSpec.describe "Api::V1::Main", type: :request do

  let!(:fund_category) { create(:fund_category, name: '格桑花') }
  let!(:fund) { create(:fund, name: '格桑花非指定', fund_category: fund_category) }
  let!(:login_user) { create(:user) }
  let!(:team) { create(:team, creater: login_user, manager: login_user) }
  let!(:team_user) { create(:user, team: team) }
  let!(:banner) { create(:advert) }
  let!(:promoter) { create(:user) }

  describe '获取滚动Banner' do
    it '获取Banner' do
      get banners_api_v1_main_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data].first[:id]).to eq banner.id
    end
  end

  describe '单次捐助' do
    it '捐助给所选可捐助项目' do
      post gsh_api_v1_donate_path,
           params: {amount: '5000', donate_item: {"name"=>"一对一", "value"=>"1"},
                    donor_name: '好心人', by_team: false, pay_method: 'weixin'},
           headers: api_v1_headers(login_user)
      api_v1_expect_success
      # expect(json_body[:data][:recordState]).to eq true
    end
  end

  describe '单次捐助(有劝捐人)' do
    it '捐助给所选可捐助项目' do
      post gsh_api_v1_donate_path,
           params: {amount: '5000', donate_item: {"name"=>"一对一", "value"=>"1"},
                    donor_name: '好心人', by_team: false, pay_method: 'weixin', promoter_id: promoter.id},
           headers: api_v1_headers(login_user)
      api_v1_expect_success
      # expect(json_body[:data][:recordState]).to eq true
      # expect(json_body[:data][:promoterId]).to eq promoter.id
    end
  end

  describe '月捐' do
    it '捐助给所选可捐助项目' do
      post gsh_api_v1_donate_path,
           params: {amount: '5000', donate_item: {"name"=>"一对一", "value"=>"1"},
                    period: '3', pay_method: 'weixin'},
           headers: api_v1_headers(login_user)
      api_v1_expect_success
      # expect(json_body[:data][:recordState]).to eq true
    end
  end

  describe '获取活动' do
    it '获取活动' do
      get campaigns_api_v1_main_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end
  end

  describe '获取悦读' do
    it '获取悦读' do
      get reads_api_v1_main_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end
  end

  describe '获取广播' do
    it '获取广播' do
      get radios_api_v1_main_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end
  end

  describe '获取护花' do
    it '获取护花' do
      get flowers_api_v1_main_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end
  end

end
