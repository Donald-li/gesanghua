require 'rails_helper'

RSpec.describe "Api::V1::Main", type: :request do

  let!(:fund_category) { create(:fund_category, name: '格桑花') }
  let!(:fund) { create(:fund, name: '格桑花非指定', fund_category: fund_category) }
  let!(:login_user) { create(:user) }
  let!(:team) { create(:team, creater: login_user, manager: login_user) }
  let!(:team_user) { create(:user, team: team) }
  let!(:banner) { create(:advert) }
  let!(:promoter) { create(:user) }

  describe '捐助项测试' do
    it '获取捐助项' do
      get api_v1_donate_items_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data].count).to eq DonateItem.show.count
    end
  end

end
