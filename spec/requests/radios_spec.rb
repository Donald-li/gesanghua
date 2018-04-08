require 'rails_helper'

RSpec.describe "Api::V1::Radios", type: :request do

  let!(:login_user) { create(:user) }
  let(:radio) { create(:project, kind: :goods) }
  let!(:season) { create(:project_season, project: radio) }
  let!(:school) { create(:school) }
  let!(:apply) { create(:project_season_apply, school: school, season: season, project: radio) }

  describe '物资类项目' do
    it '项目简介' do
      get api_v1_good_path(id: radio), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '可筛选地址' do
      get get_address_list_api_v1_good_path(id: radio), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '悦读列表' do
      get applies_list_api_v1_good_path(id: radio), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end
  end

end
