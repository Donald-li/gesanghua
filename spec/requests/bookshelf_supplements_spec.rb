require 'rails_helper'
RSpec.describe "Api::V1::BookshelfSupplements", tye: :request do
  let!(:login_user) { create(:user) }
  let!(:user) { create(:user) }
  let!(:school) { create(:school, user: user) }
  let!(:teacher) { create(:teacher, school: school, user: user) }
  let!(:project) { Project.find_by(alias: 'read') }
  let!(:season) { create(:project_season, project: project) }
  let!(:apply) { create(:project_season_apply, project: project, season: season, teacher: teacher, school: school) }
  let!(:bookshelf) { create(:project_season_apply_bookshelf, project: project, season: season, apply: apply, school: school) }
  let!(:supply) { create(:bookshelf_supplement, apply: apply, bookshelf: bookshelf) }

  describe '补书申请' do
    it '新增补书申请' do
      post api_v1_bookshelf_supplements_path,
          params: {class: {class_id: [bookshelf.id], loss: '33', supply: '12'}, id: bookshelf.id},
           headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(BookshelfSupplement.last.loss) === 33
    end

    it '获取待修改的补书详情' do
      get edit_api_v1_bookshelf_supplement_path(id: supply.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:supplement][:id]).to eq supply.id
    end

    it '修改补书申请' do
      patch api_v1_bookshelf_supplement_path(id: supply.id, class:{class_id: [bookshelf.id], loss: '22'}), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(supply.loss) === 33
    end

  end


end