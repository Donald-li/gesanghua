require 'rails_helper'

RSpec.describe "Api::V1::Cooperation::CampMembers", type: :request do

  let!(:login_user) { create(:user) }
  let!(:project) { Project.camp_project }
  let!(:camp) { create(:camp, manager: login_user) }
  let!(:apply) { create(:project_season_apply, project: project, camp: camp) }
  let!(:school) { create(:school) }
  let!(:teacher) { create(:teacher, school: school, user: login_user, kind: 'headmaster')}
  let!(:apply_camp) { create(:project_season_apply_camp, apply: apply, school: school, camp: camp) }
  let!(:student1) {create(:project_season_apply_camp_member, kind: 'student', state: 'pass', apply: apply, apply_camp: apply_camp, camp: camp, school: school)}
  let!(:student2) {create(:project_season_apply_camp_member, kind: 'student', state: 'pass', apply: apply, apply_camp: apply_camp, camp: camp, school: school)}
  let!(:teacher) {create(:project_season_apply_camp_member, kind: 'teacher', state: 'pass', apply: apply, apply_camp: apply_camp, camp: camp, school: school)}

  describe '协作平台-探索营管理' do
    it '名单列表' do
      get api_v1_cooperation_camp_members_path(camp_id: apply_camp.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '学生列表' do
      student1.draft!
      get students_api_v1_cooperation_camp_members_path(camp_id: apply_camp.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:students].count).to eq 1
    end

    it '教师列表' do
      teacher.draft!
      get teachers_api_v1_cooperation_camp_members_path(camp_id: apply_camp.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:teachers].count).to eq 1
    end

    it '提交学生' do
      post api_v1_cooperation_camp_members_path(camp_id: apply_camp.id),
          params: {
              camp_member: {
                  project_season_apply_camp_id: apply_camp.id,
                  name: FFaker::NameCN.name,
                  id_card: '450125197708261213',
                  nation: 'hanzu',
                  level: 'junior',
                  grade: 'one',
                  teacher_name: FFaker::NameCN.name,
                  teacher_phone: '18688888888',
                  guardian_name: FFaker::NameCN.name,
                  guardian_phone: '18688888888',
                  kind: 'student',
                  description: FFaker::LoremCN.sentence(5)
              },
              image: {id: ''}
          }, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:result]).to eq true
    end

    it '提交教师' do
      post api_v1_cooperation_camp_members_path(camp_id: apply_camp.id),
           params: {
               camp_member: {
                   project_season_apply_camp_id: apply_camp.id,
                   name: FFaker::NameCN.name,
                   id_card: '450125197708261213',
                   nation: 'hanzu',
                   kind: 'student'
               },
               image: {id: ''}
           }, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:result]).to eq true
    end

    it '修改成员信息' do
      get edit_api_v1_cooperation_camp_member_path(camp_id: apply_camp.id, id: student1.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:id]).to eq student1.id
    end

    it '更新学生' do
      patch api_v1_cooperation_camp_member_path(camp_id: apply_camp.id, id: student1.id),
           params: {
               camp_member: {
                   project_season_apply_camp_id: apply_camp.id,
                   name: FFaker::NameCN.name,
                   id_card: '450125197708261213',
                   nation: 'hanzu',
                   level: 'junior',
                   grade: 'one',
                   teacher_name: FFaker::NameCN.name,
                   teacher_phone: '18688888888',
                   guardian_name: FFaker::NameCN.name,
                   guardian_phone: '18688888888',
                   kind: 'student',
                   description: FFaker::LoremCN.sentence(5)
               },
               image: {id: ''}
           }, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:result]).to eq true
    end

    it '更新教师' do
      patch api_v1_cooperation_camp_member_path(camp_id: apply_camp.id, id: teacher.id),
           params: {
               camp_member: {
                   project_season_apply_camp_id: apply_camp.id,
                   name: FFaker::NameCN.name,
                   id_card: '450125197708261213',
                   nation: 'hanzu',
                   kind: 'student'
               },
               image: {id: ''}
           }, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:result]).to eq true
    end

    it '获取分享链接' do
      get qrcode_api_v1_cooperation_camp_members_path(camp_id: apply_camp.id, kind: 'student'), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:qrcode_url]).to eq "#{Settings.m_root_url}/form/link-to-visit?type=camp_member&kind=student&id=#{apply_camp.id}"
    end

    it '修改学生推荐理由' do
      get edit_reason_api_v1_cooperation_camp_member_path(camp_id: apply_camp.id, id: student1.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data]).to eq student1.reason
    end

    it '更新学生推荐理由' do
      post update_reason_api_v1_cooperation_camp_member_path(camp_id: apply_camp.id, id: student1.id, reason: '学习优秀'), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:result]).to eq true
    end


  end

end
