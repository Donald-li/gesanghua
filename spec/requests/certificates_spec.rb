require 'rails_helper'

RSpec.describe "Api::V1::Certificates", type: :request do

  let!(:login_user) { create(:user) }
  describe '捐赠证书' do

    it '获取捐赠证书信息' do
      user = create(:user)
      school = create(:school)
      teacher = create(:teacher, school: school, user: user)
      project = create(:project)
      season = create(:project_season, project: project)
      apply = create(:project_season_apply, project: project, season: season, teacher: teacher)
      child = create(:project_season_apply_child, project: project, season: season, apply: apply, school: school)

      donations = create_list :donation, 6, project: project, season: season, apply: apply, donor: user, pay_state: 'paid'
      income_record = create(:income_record, donation: donations.last ,certificate_no: '18000000001111' )
      get api_v1_certificate_path(income_record.certificate_no), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

  end
end
