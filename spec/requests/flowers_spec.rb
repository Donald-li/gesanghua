require 'rails_helper'

RSpec.describe "Api::V1::Flowers", type: :request do

  let!(:login_user) { create(:user) }
  let(:flower) { create(:project) }
  let!(:season) { create(:project_season, project: flower) }
  let!(:apply) { create(:project_season_apply, season: season, project: flower) }
  let!(:school) { create(:school) }

  describe '悦读主页' do
    it '项目简介' do
      get api_v1_flower_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '可筛选地址' do
      get get_address_list_api_v1_flower_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '悦读列表' do
      get applies_list_api_v1_flower_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end
  end

end
