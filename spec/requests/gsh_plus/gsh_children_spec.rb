require 'rails_helper'

RSpec.describe "Api::V1::GshPlus::GshChildren", type: :request do

  let!(:login_user) { create(:user) }
  let!(:pair) { create(:project) }
  let!(:season) { create(:project_season, project: pair) }
  let!(:apply) { create(:project_season_apply, season: season, project: pair) }
  let!(:school) { create(:school) }
  let!(:gsh_child) {create(:gsh_child, id_card: '110229190001010913')}
  let!(:child1) { create(:project_season_apply_child, state: 1, approve_state: 2, kind: 1, project: pair, season: season, apply: apply, school: school, id_card: '110229190001010913', gsh_child: gsh_child) }
  let!(:child2) { create(:project_season_apply_child, name: '陈同学',district: '630121', state: 1, approve_state: 2, kind: 1, project: pair, season: season, apply: apply, school: school, id_card: '110229190001010913') }

  describe '格桑花+认证格桑花孩子' do
    it '匹配格桑花孩子' do
      child1.approve_pass
      post match_identity_api_v1_gsh_plus_gsh_children_path,
           params: {
               child: {name: child1.name, id_card: child1.id_card}
           }, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:result]).to eq true
    end

    it '确认格桑花孩子' do
      child1.approve_pass
      get confirm_identity_api_v1_gsh_plus_gsh_children_path,
           params: {
               child_id: gsh_child.id
           }, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end
  end

end
