require 'rails_helper'

RSpec.describe "Api::V1::ChildrenGrants", type: :request do

  let!(:login_user) { create(:user) }
  let!(:pair) { create(:project) }
  let!(:season) { create(:project_season, project: pair) }
  let!(:apply) { create(:project_season_apply, season: season, project: pair) }
  let!(:school) { create(:school) }
  let!(:child1) { create(:project_season_apply_child, state: 1, approve_state: 2, kind: 1, project: pair, season: season, apply: apply, school: school) }

  describe '孩子资助年度列表' do
    it '资助年度列表' do
      child1.approve_pass
      get grants_list_api_v1_children_grants_path(id: child1.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:grants].first[:amount]) == '2100'
    end

  end

end
