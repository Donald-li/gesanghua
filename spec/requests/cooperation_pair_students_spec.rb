require 'rails_helper'

RSpec.describe "Api::V1::CooperationPairStudents", type: :request do

  let!(:login_user) { create(:user) }
  let!(:school) { create(:school) }
  let!(:pair) { create(:project) }
  let!(:season) { create(:project_season, project: pair) }
  let!(:apply) { create(:project_season_apply, season: season, project: pair, school: school) }
  let!(:child1) { create(:project_season_apply_child, state: 1, approve_state: 2, kind: 1, project: pair, season: season, apply: apply, school: school, id_card: '110229190001010913') }
  let!(:child2) { create(:project_season_apply_child, name: '陈同学',district: '630121', state: 1, approve_state: 2, kind: 1, project: pair, season: season, apply: apply, school: school, id_card: '110229190001010913') }

  describe '协作平台' do

    it '获取结对申请孩子' do
      get api_v1_cooperation_pair_students_path(id: apply.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:apply_students].count) === apply.children.count
    end

    it '创建结对申请孩子' do
      post api_v1_cooperation_pair_students_path,
           params: {apply_id: apply.id, nation: ['hanzu'], level: ['junior'], grade: ['one'], semester: ['last_term'],
                    name: '林则徐', id_card: '620600198605077807', teacher_name: '孔先生', teacher_phone: '17888886677', description: FFaker::LoremCN.sentence(3),
                    father: FFaker::NameCN.name, father_job: FFaker::NameCN.name, mother: FFaker::NameCN.name, mother_job: FFaker::NameCN.name,
                    guardian: FFaker::NameCN.name, guardian_relation: FFaker::NameCN.name, guardian_phone: '17666667777', address: FFaker::NameCN.name,
                    family_income: '1760', family_expenditure: '1000', income_source: FFaker::NameCN.name, family_condition: '贫困', brothers: '无',
                    id_image: [''], apply_one: [''], apply_two: [''], room_image: [''], yard_image: [''], poverty: ['']},
           headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:result]).to eq true
    end

    it '获取待修改的结对申请孩子' do
      get edit_api_v1_cooperation_pair_student_path(id: child1.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:student][:id]).to eq child1.id
    end

    it '修改结对申请孩子' do
      patch api_v1_cooperation_pair_student_path(student_id: child1.id, id: child1.id),
           params: {apply_id: apply.id, nation: ['hanzu'], level: ['junior'], grade: ['one'], semester: ['last_term'],
                    name: '林则徐', id_card: '620600198605077807', teacher_name: '孔先生', teacher_phone: '17888886677', description: FFaker::LoremCN.sentence(3),
                    father: FFaker::NameCN.name, father_job: FFaker::NameCN.name, mother: FFaker::NameCN.name, mother_job: FFaker::NameCN.name,
                    guardian: FFaker::NameCN.name, guardian_relation: FFaker::NameCN.name, guardian_phone: '17666667777', address: FFaker::NameCN.name,
                    family_income: '1760', family_expenditure: '1000', income_source: FFaker::NameCN.name, family_condition: '贫困', brothers: '无',
                    id_image: [''], apply_one: [''], apply_two: [''], room_image: [''], yard_image: [''], poverty: ['']},
           headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:result]).to eq true
    end

    it '获取分享链接' do
      get qrcode_api_v1_cooperation_pair_students_path(id: apply.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:qrcode_url]).to eq URI::encode "#{Settings.m_root_url}/form/pair-guide?code=#{apply.code}&school_name=#{school.name}&apply_id=#{apply.id}"
    end

    it '编辑推荐理由' do
      get edit_reason_api_v1_cooperation_pair_student_path(id: child1.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:apply_student][:id]) === child1.id
    end

    it '修改推荐理由' do
      patch update_reason_api_v1_cooperation_pair_student_path(id: child1.id),
          params: {cooperation_pair_student: {reason: FFaker::NameCN.name}}, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end


    # 这个代码删掉了
    it '学生中心管理-获取孩子结对助学捐助信息' do
      child1.approve_pass
      get child_grants_api_v1_cooperation_pair_students_path,
           params: {
               id: child1.gsh_child.id
           }, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end
  end

end
