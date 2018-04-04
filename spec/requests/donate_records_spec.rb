require 'rails_helper'

RSpec.describe "Api::V1::DonateRecords", type: :request do

  let!(:login_user) { create(:user) }
  describe '捐助记录' do

    it '一对一项目捐助记录' do
      user = create(:user)
      school = create(:school)
      teacher = create(:teacher, school: school, user: user)
      project = create(:project)
      season = create(:project_season, project: project)
      apply = create(:project_season_apply, project: project, season: season, teacher: teacher)
      child = create(:project_season_apply_child, project: project, season: season, apply: apply, school: school)

      create_list :donate_record, 6, project: project, season: season, apply: apply, donor: user
      get api_v1_donate_records_path(project_id: project.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '获取捐赠证书信息' do
      user = create(:user)
      school = create(:school)
      teacher = create(:teacher, school: school, user: user)
      project = create(:project)
      season = create(:project_season, project: project)
      apply = create(:project_season_apply, project: project, season: season, teacher: teacher)
      child = create(:project_season_apply_child, project: project, season: season, apply: apply, school: school)

      donations = create_list :donation, 6, project: project, season: season, apply: apply, donor: user
      get certificate_api_v1_donate_record_path(id: donations.last), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

  end
end
