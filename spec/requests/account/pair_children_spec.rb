require 'rails_helper'

RSpec.describe "Api::V1::Children::PairChildren", type: :request do

  let!(:login_user) {create(:user)}
  let!(:pair) {create(:project)}
  let!(:season) {create(:project_season, project: pair)}
  let!(:apply) {create(:project_season_apply, season: season, project: pair)}
  let!(:school) {create(:school)}
  let!(:child1) {create(:project_season_apply_child, state: 1, approve_state: 2, kind: 1, project: pair, season: season, apply: apply, school: school)}
  let!(:child2) {create(:project_season_apply_child, name: '陈同学', district: '630121', state: 1, approve_state: 2, kind: 1, project: pair, season: season, apply: apply, school: school)}

  describe '测试我的结对' do
    it '获取结对孩子列表' do
      child1.approve_pass
      post settlement_api_v1_pair_children_path,
           params: {id: child1.id, by_team: false,
                    donor_name: '好心人', total_amount: '2100',
                    paymethod: 'weixin', selectedGrants: child1.donate_record_builder},
           headers: api_v1_headers(login_user)
      api_v1_expect_success

      get api_v1_account_pair_children_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end
  end

end
