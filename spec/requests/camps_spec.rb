require 'rails_helper'

RSpec.describe "Api::V1::Camps", type: :request do

  let!(:login_user) { create(:user) }
  let!(:project) { Project.camp_project }
  let!(:camp) { create(:camp, manager: login_user) }
  let!(:apply) { create(:project_season_apply, project: project, camp: camp) }
  let!(:school) { create(:school) }
  let!(:apply_camp) { create(:project_season_apply_camp, apply: apply, school: school, camp: camp) }

  describe '探索营主页' do
    it '项目简介' do
      get api_v1_camp_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '可筛选地址' do
      get get_address_list_api_v1_camp_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '探索营列表' do
      get applies_list_api_v1_camp_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end
  end

end
