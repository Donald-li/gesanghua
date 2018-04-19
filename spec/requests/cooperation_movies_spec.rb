require 'rails_helper'
RSpec.describe "Api::V1::CooperationMovie", tye: :request do
  let!(:login_user) { create(:user) }
  let!(:school) { create(:school, user: login_user) }
  let!(:teacher) { create(:teacher, school: school, user: login_user, kind: 'headmaster') }
  let!(:project) {  Project.movie_project }
  let!(:season) { create(:project_season, project: project) }
  let!(:apply) { create(:project_season_apply, project: project, season: season, teacher: teacher, school: school) }
  let!(:logistic) { create(:logistic, owner: apply) }

  describe '测试协作平台-观影项目管理' do
    it '观影项目列表' do
      get api_v1_cooperation_movies_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:applies]).to eq []

      login_user.add_role(:headmaster)
      login_user.save

      get api_v1_cooperation_movies_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:applies][0][:id]).to eq apply.id

    end

    it '查看观影申请' do
      get api_v1_cooperation_movie_path(id: apply.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:school][:id]).to eq school.id
      expect(json_body[:data][:apply][:id]).to eq apply.id

    end

    it '待新增观影申请' do
      get new_api_v1_cooperation_movie_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:school][:id]).to eq school.id

    end

    it '创建观影申请' do
      apply.destroy
      post api_v1_cooperation_movies_path,
          params: {movie_apply: {season:[season.id], student_number: '30', describe: FFaker::LoremCN.sentence,
          contact_name: FFaker::NameCN.name, contact_phone: '17888889999', location: [110000, 110100, 110101], address: '某街'}},
           headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:result]).to eq true

    end

    it '修改观影申请' do
      patch api_v1_cooperation_movie_path(id: apply.id),
           params: {movie_apply: {season:[season.id], student_number: '30', describe: FFaker::LoremCN.sentence,
                                 contact_name: FFaker::NameCN.name, contact_phone: '17888889999', location: [110000, 110100, 110101], address: '某街'}},
           headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:result]).to eq true

    end

  end


end
