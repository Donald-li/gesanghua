require 'rails_helper'

RSpec.describe "Api::V1::GshPlus::Main", type: :request do

  let!(:login_user) { create(:user) }
  let!(:pair) { create(:project) }
  let!(:season) { create(:project_season, project: pair) }
  let!(:apply) { create(:project_season_apply, season: season, project: pair) }
  let!(:school) { create(:school, user: login_user, approve_state: 'pass') }
  let!(:child1) { create(:project_season_apply_child, state: 1, approve_state: 2, kind: 1, project: pair, season: season, apply: apply, school: school) }

  describe '格桑花+引导页' do
    it '获取申请状态' do
      get api_v1_gsh_plus_mains_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:school_apply_state]) === 'pass'
      expect(json_body[:data][:volunteer_apply_state]) === 'default'
      expect(json_body[:data][:gsh_child_state]).to eq false
    end

  end

end
