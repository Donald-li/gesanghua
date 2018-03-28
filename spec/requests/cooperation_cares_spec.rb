require 'rails_helper'
RSpec.describe "Api::V1::CooperationCares", tye: :request do
  let!(:login_user) { create(:user) }
  let!(:school) { create(:school, user: login_user) }
  let!(:teacher) { create(:teacher, school: school, user: login_user, kind: 'headmaster') }
  let!(:project) {  Project.care_project }
  let!(:season) { create(:project_season, project: project) }
  let!(:apply) { create(:project_season_apply, project: project, season: season, teacher: teacher, school: school) }
  let!(:logistic) { create(:logistic, owner: apply) }

  describe '测试协作平台-护花项目管理' do
    it '护花项目列表' do
      get api_v1_cooperation_cares_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:applies]).to eq []

      login_user.add_role(:headmaster)
      login_user.save

      get api_v1_cooperation_cares_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:applies][0][:id]).to eq apply.id

    end

    it '查看护花申请' do
      get api_v1_cooperation_care_path(id: apply.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:school][:id]).to eq school.id
      expect(json_body[:data][:apply][:id]).to eq apply.id

    end

    it '待新增护花申请' do
      get new_api_v1_cooperation_care_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:school][:id]).to eq school.id

    end

    it '创建护花申请' do
      post api_v1_cooperation_cares_path,
          params: {care_apply: {season:[season.id], student_number: '30', describe: FFaker::LoremCN.sentence,
          contact_name: FFaker::NameCN.name, contact_phone: '17888889999', location: [110000, 110100, 110101], address: '某街'}},
           headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:result]).to eq true

    end

    it '修改护花申请' do
      patch api_v1_cooperation_care_path(id: apply.id),
           params: {care_apply: {season:[season.id], student_number: '30', describe: FFaker::LoremCN.sentence,
                                 contact_name: FFaker::NameCN.name, contact_phone: '17888889999', location: [110000, 110100, 110101], address: '某街'}},
           headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:result]).to eq true

    end

    it '查看物流' do
      get show_logistic_api_v1_cooperation_care_path(id: apply.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end


  end


end