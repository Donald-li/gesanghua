require 'rails_helper'

RSpec.describe "Api::V1::Main", type: :request do

  let!(:fund_category) { create(:fund_category, name: '格桑花') }
  let!(:fund) { create(:fund, name: '格桑花非指定', fund_category: fund_category) }
  let!(:login_user) { create(:user) }
  let!(:team) { create(:team, creater: login_user) }
  let!(:team_user) { create(:user, team: team) }

  describe '单次捐助' do
    it '捐助给格桑花' do
      post contribute_api_v1_main_path,
           params: {amount: '5000', project: {"name"=>"格桑花", "value"=>"toGsh"},
                    donor_name: '好心人', month: false,
                    by_team: false, pay_method: 'weixin'},
           headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:pay_state]).to eq true
    end

    it '捐助给指定项目' do
      create(:project)
      post contribute_api_v1_main_path,
           params: {amount: '5000', project: {"name"=>"一对一", "value"=>"toPair"},
                    donor_name: '好心人', month: false,
                    by_team: false, pay_method: 'weixin'},
           headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:pay_state]).to eq true
    end
  end
end
