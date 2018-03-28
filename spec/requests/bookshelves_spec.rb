require 'rails_helper'
RSpec.describe "Api::V1::Bookshelves", tye: :request do
  let!(:login_user) { create(:user) }
  let!(:user) { create(:user) }
  let!(:school) { create(:school, user: user) }
  let!(:teacher) { create(:teacher, school: school, user: user) }
  let!(:project) { Project.find_by(alias: 'read') }
  let!(:season) { create(:project_season, project: project) }
  let!(:apply) { create(:project_season_apply, project: project, season: season, teacher: teacher, school: school) }
  let!(:bookshelf) { create(:project_season_apply_bookshelf, project: project, season: season, apply: apply, school: school) }
  let!(:logistic) { create(:logistic, owner: bookshelf) }

  describe '测试图书角' do
    it '图书角冠名' do
      post define_name_api_v1_bookshelf_path(id: bookshelf.id, define_name: '11图书角'), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(bookshelf.reload.title).to eq '11图书角'
    end

    it '提交图书角申请' do
      post api_v1_bookshelves_path,
          params: {class: {classname: '希望班', student_number: '30'}},
           headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(ProjectSeasonApplyBookshelf.last.classname).to eq '希望班'
    end

    it '获取待修改的图书角资料' do
      get edit_api_v1_bookshelf_path(id: bookshelf.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:bookshelf][:id]).to eq bookshelf.id

    end

    it '修改图书角资料' do
      patch api_v1_bookshelf_path(id: bookshelf.id, class: {classname: '希望班11', student_number: '30'}), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(bookshelf.reload.classname).to eq '希望班11'

    end

    it '获取图书角列表' do
      get class_list_api_v1_bookshelf_path(id: apply.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data].count).to eq apply.bookshelves.pass.count

    end

    it '获取图书角物流信息' do
      get show_logistic_api_v1_bookshelf_path(id: bookshelf.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '获取图书角详情' do
      get api_v1_bookshelf_path(id: bookshelf.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:id]).to eq bookshelf.id

    end

  end


end