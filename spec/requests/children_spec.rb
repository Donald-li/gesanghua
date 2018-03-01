require 'rails_helper'

RSpec.describe "Api::V1::Children", type: :request do

  let!(:login_user) { create(:user) }
  let!(:pair) { create(:project) }
  let!(:season) { create(:project_season, project: pair) }
  let!(:apply) { create(:project_season_apply, season: season, project: pair) }
  let!(:school) { create(:school) }
  let!(:child1) { create(:project_season_apply_child, state: 1, approve_state: 2, kind: 1, project: pair, season: season, apply: apply, school: school, id_card: '110229190001010913') }
  let!(:child2) { create(:project_season_apply_child, name: '陈同学',district: '630121', state: 1, approve_state: 2, kind: 1, project: pair, season: season, apply: apply, school: school, id_card: '110229190001010913') }


  # describe '孩子列表' do
  #   before {
  #     child1.approve_pass
  #     child2.approve_pass
  #   }
  #   it '获取一对一孩子列表' do
  #     get api_v1_children_path, headers: api_v1_headers(login_user)
  #     api_v1_expect_success
  #     expect(json_body[:data][:children].second[:id]).to eq child1.id
  #   end
  #
  #   it '根据地区获取一对一孩子列表' do
  #     get api_v1_children_path(district: '630121'), headers: api_v1_headers(login_user)
  #     api_v1_expect_success
  #     expect(json_body[:data][:children].first[:id]).to eq child2.id
  #   end
  # end

  describe '筛选地址' do
    it '获取可筛选地址' do
      get get_address_list_api_v1_children_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:city].first[:value]).to eq '630100'
    end
  end

end
