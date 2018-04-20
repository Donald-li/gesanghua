require 'rails_helper'

RSpec.describe "Api::V1::Camps", type: :request do

  let!(:login_user) { create(:user) }
  let!(:project) { Project.camp_project }
  let!(:camp) { create(:camp, manager: login_user) }
  let!(:apply) { create(:project_season_apply, project: project, camp: camp) }
  let!(:school) { create(:school) }
  let!(:apply_camp) { create(:project_season_apply_camp, apply: apply, school: school, camp: camp) }
  let!(:student1) {create(:project_season_apply_camp_member, kind: 'student', state: 'pass', apply: apply, apply_camp: apply_camp, camp: camp, school: school)}
  let!(:student2) {create(:project_season_apply_camp_member, kind: 'student', state: 'pass', apply: apply, apply_camp: apply_camp, camp: camp, school: school)}
  let!(:teacher) {create(:project_season_apply_camp_member, kind: 'teacher', state: 'pass', apply: apply, apply_camp: apply_camp, camp: camp, school: school)}
  let!(:feedback) {create(:feedback, type: 'continual_feedback', owner: apply, state: 'show', recommend: 'recommend', user: login_user, project: project)}

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

    it '探索营详情' do
      get apply_camp_api_v1_camp_path(id: apply.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '探索营成员' do
      apply_camp.approved!
      get member_api_v1_camp_path(id: apply.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:member].count) == apply_camp.camp_members.pass.count
    end

    it '获取探索营执行反馈' do
      get feedback_api_v1_camp_path(id: apply.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '举报探索营执行' do
      code = SmsCode.send_code('17866539878', 'verify_profile')
      post complaint_api_v1_camp_path,
          params: {id: apply.id,
                   complaint: {contact_name: '刘某', contact_phone: '17866539878', content: '描述内容不实'},
                   code: code.code,
                   images: {}},
          headers: api_v1_headers(login_user)
      api_v1_expect_success
    end


  end

end
