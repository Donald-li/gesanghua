require 'rails_helper'
RSpec.describe "Api::V1::Campaigns", tye: :request do
  let!(:login_user) { create(:user) }
  let!(:category) { create(:campaign_category) }
  let!(:campaign1) { create(:campaign, campaign_category: category) }
  let!(:campaign2) { create(:campaign, campaign_category: category) }
  let!(:enlist) { create(:campaign_enlist, campaign: campaign1, user: login_user) }

  describe '测试活动' do

    it '获取活动列表' do
      get api_v1_campaigns_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:list].count).to eq Campaign.show.count

    end

    it '获取活动详情' do
      get api_v1_campaign_path(id: campaign1.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:id]).to eq campaign1.id

    end

    it '活动报名' do
      post apply_api_v1_campaign_path(id: campaign1.id),
          params: {contact_name: '林则徐', contact_phone: '17888886666', number: '1', remark: '备注备注'},
          headers: api_v1_headers(login_user)
      api_v1_expect_success

    end

    it '报名成功推荐其他活动' do
      get success_api_v1_campaign_path(id: enlist.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:campaign][:id]).to eq campaign2.id
    end

  end


end