require 'rails_helper'

RSpec.describe "Api::V1::Children", type: :request do

  let!(:pair) { create(:project) }
  let!(:season) { create(:project_season, project: pair) }
  let!(:apply) { create(:project_season_apply, season: season, project: pair) }
  let!(:school) { create(:school) }
  let!(:child) { create(:project_season_apply_child, state: 1, approve_state: 2, kind: 1, project: pair, season: season, apply: apply, school: school) }

  describe '孩子列表' do
    it '获取结对孩子列表' do
      get api_v1_children_path
      api_v1_expect_success
      expect(json_body[:data][:children].first[:name]).to eq '李*学'
    end
  end

  describe '筛选地址' do
    it '获取可筛选地址' do
      get get_address_list_api_v1_children_path
      api_v1_expect_success
      expect(json_body[:data][:city].first[:value]).to eq '630100'
    end
  end

end
