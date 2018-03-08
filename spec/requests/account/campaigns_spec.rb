require 'rails_helper'

RSpec.describe "Api::V1::Account::Campaigns", type: :request do

  let!(:login_user) {create(:user)}
  let!(:user1) {create(:user)}
  let!(:user2) {create(:user)}
  let!(:campaign_category) {create(:campaign_category)}
  let!(:campaign1) {create(:campaign, campaign_category: campaign_category)}
  let!(:campaign2) {create(:campaign, campaign_category: campaign_category)}
  let!(:campaign_enlist1) {create(:campaign_enlist, campaign: campaign1, user_id: login_user.id, number: 2, remark: '女装S一件，男装M一件', total: 600, contact_name: '徐恒', contact_phone: '17660643271', payment_state: 'paid')}
  let!(:campaign_enlist2) {create(:campaign_enlist, campaign: campaign1, user_id: user1.id, number: 2, remark: '女装S一件，男装M一件', total: 600, contact_name: '徐恒', contact_phone: '17660643271', payment_state: 'paid')}
  let!(:campaign_enlist3) {create(:campaign_enlist, campaign: campaign2, user_id: login_user.id, number: 2, remark: '女装S一件，男装M一件', total: 600, contact_name: '徐恒', contact_phone: '17660643271', payment_state: 'paid')}

  describe '测试我的活动' do
    it '获取活动列表' do
      get api_v1_account_campaigns_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:campaigns].count) === 2
    end
  end

end
