require 'rails_helper'

RSpec.describe "Api::V1::Staff::Grants", type: :request do

  let!(:login_user) { create(:user) }
  let!(:user) { create(:user) }
  let!(:school) { create(:school, user: user) }
  let!(:teacher) { create(:teacher, school: school, user: user) }
  let!(:project) { create(:project) }
  let!(:season) { create(:project_season, project: project) }
  let!(:apply) { create(:project_season_apply, project: project, season: season, teacher: teacher, school: school) }
  let!(:child) { create(:project_season_apply_child, project: project, season: season, apply: apply, school: school, semester: 'next_term') }
  let!(:batch){ create(:grant_batch, project: Project.pair_project)}

  describe '结对助学发放' do
    it '发放列表' do
      child.approve_pass
      child.gsh_child_grants.update(grant_batch_id: batch.id)
      get api_v1_staff_grant_batch_grants_path(grant_batch_id: batch.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      # expect(json_body[:data][:grants].first[:title]).to eq '2019 - 2020 学年'
    end
  end

end
