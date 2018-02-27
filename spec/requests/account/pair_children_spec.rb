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

    it '获取孩子信箱列表' do
      Continual.create(content: '谢谢所有参与表演的音乐家们，谢谢所有无私奉献的志愿者，感谢大家对我的帮助，我一定努力学习，长大成为一个有用的人', kind: 2, user: login_user, project_id: child1.project_id, project_season_id: child1.season.id, project_season_apply_id: child1.project_season_apply_id, project_season_apply_child_id: child1.id, owner_type: 'ProjectSeasonApplyChild', owner_id: child1.id)
      get feedback_list_api_v1_account_pair_children_path(child_id: child1.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end
  end

end
