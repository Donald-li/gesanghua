require 'rails_helper'

RSpec.describe "Api::V1::Cooperation::Camps", type: :request do

  let!(:login_user) { create(:user) }
  let!(:project) { Project.camp_project }
  let!(:camp) { create(:camp, manager: login_user) }
  let!(:apply) { create(:project_season_apply, project: project, camp: camp) }
  let!(:school) { create(:school, user: login_user) }
  let!(:teacher) { create(:teacher, school: school, user: login_user, kind: 'headmaster')}
  let!(:apply_camp) { create(:project_season_apply_camp, apply: apply, school: school, camp: camp) }
  let!(:student1) {create(:project_season_apply_camp_member, kind: 'student', state: 'pass', apply: apply, apply_camp: apply_camp, camp: camp, school: school)}
  let!(:student2) {create(:project_season_apply_camp_member, kind: 'student', state: 'pass', apply: apply, apply_camp: apply_camp, camp: camp, school: school)}
  let!(:teacher) {create(:project_season_apply_camp_member, kind: 'teacher', state: 'pass', apply: apply, apply_camp: apply_camp, camp: camp, school: school)}

  describe '协作平台-探索营管理' do
    it '申请列表' do
      login_user.add_role(:headmaster)
      login_user.save
      get api_v1_cooperation_camps_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '申请详情' do
      get api_v1_cooperation_camp_path(id: apply_camp.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:id]).to eq apply_camp.id
    end

    it '查看通过审核名单' do
      get verified_members_api_v1_cooperation_camps_path(id: apply_camp.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:member].count).to eq 3
    end

    it '提交名单' do
      post submit_api_v1_cooperation_camps_path(id: apply_camp.id, member_ids: [student1.id, student2.id, teacher.id]), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:result]).to eq true
    end

  end

end
