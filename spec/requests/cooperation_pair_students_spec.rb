require 'rails_helper'

RSpec.describe "Api::V1::CooperationPairStudents", type: :request do

  let!(:login_user) { create(:user) }
  let!(:pair) { create(:project) }
  let!(:season) { create(:project_season, project: pair) }
  let!(:apply) { create(:project_season_apply, season: season, project: pair) }
  let!(:school) { create(:school) }
  let!(:child1) { create(:project_season_apply_child, state: 1, approve_state: 2, kind: 1, project: pair, season: season, apply: apply, school: school, id_card: '110229190001010913') }
  let!(:child2) { create(:project_season_apply_child, name: '陈同学',district: '630121', state: 1, approve_state: 2, kind: 1, project: pair, season: season, apply: apply, school: school, id_card: '110229190001010913') }

  describe '协作平台' do
    # 这个代码删掉了
    it '结对反馈管理-获取孩子一对一捐助信息' do
      child1.approve_pass
      get child_grants_api_v1_cooperation_pair_students_path,
           params: {
               id: child1.gsh_child.id
           }, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end
  end

end
