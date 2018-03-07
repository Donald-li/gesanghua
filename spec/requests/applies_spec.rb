require 'rails_helper'

RSpec.describe "Api::V1::Applies", type: :request do

  let!(:login_user) { create(:user) }
  let!(:user) { create(:user) }
  let!(:school) { create(:school, user: user) }
  let!(:teacher) { create(:teacher, school: school, user: user) }
  let!(:project) { Project.find_by(alias: 'read') }
  let!(:season) { create(:project_season, project: project) }
  let!(:apply) { create(:project_season_apply, project: project, season: season, teacher: teacher, school: school) }

  describe '项目申请' do
    it '悦读申请列表' do
      get api_v1_apply_path(id: apply.id, project_name: 'read'), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end
  end

end
