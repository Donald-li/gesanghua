require 'rails_helper'

RSpec.describe "Api::V1::Account::DonateRecords", type: :request do

  let!(:login_user) { create(:user) }
  describe '捐助记录' do

    it '我的项目捐助记录' do
      school = create(:school)
      teacher = create(:teacher, school: school, user: login_user)
      project = create(:project)
      season = create(:project_season, project: project)
      apply = create(:project_season_apply, project: project, season: season, teacher: teacher)
      child = create(:project_season_apply_child, project: project, season: season, apply: apply, school: school)

      create_list :donate_record, 6, project: project, season: season, apply: apply, donor: login_user
      get api_v1_account_donate_records_path(project_id: project.id, page: 1, per: 10), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '获取项目' do
      get projects_api_v1_account_donate_records_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '获取捐助详情' do
      school = create(:school)
      teacher = create(:teacher, school: school, user: login_user)
      project = create(:project)
      season = create(:project_season, project: project)
      apply = create(:project_season_apply, project: project, season: season, teacher: teacher)
      child = create(:project_season_apply_child, project: project, season: season, apply: apply, school: school)
      record = create(:donation, project: project, season: season, apply: apply, donor: login_user, agent: login_user)

      get record_details_api_v1_account_donate_record_path(id: record.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '获取我的捐助记录' do
      school = create(:school)
      teacher = create(:teacher, school: school, user: login_user)
      project = create(:project)
      season = create(:project_season, project: project)
      apply = create(:project_season_apply, project: project, season: season, teacher: teacher)
      child = create(:project_season_apply_child, project: project, season: season, apply: apply, school: school)
      record = create(:donate_record, project: project, season: season, apply: apply, donor: login_user)

      get account_records_api_v1_account_donate_records_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '获取我的可开票捐助记录' do
      school = create(:school)
      teacher = create(:teacher, school: school, user: login_user)
      project = create(:project)
      season = create(:project_season, project: project)
      apply = create(:project_season_apply, project: project, season: season, teacher: teacher)
      child = create(:project_season_apply_child, project: project, season: season, apply: apply, school: school)
      record = create(:income_record, donor: login_user)

      get voucher_records_api_v1_account_donate_records_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

  end
end
