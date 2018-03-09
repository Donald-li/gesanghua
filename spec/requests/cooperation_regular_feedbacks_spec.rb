require 'rails_helper'

RSpec.describe "Api::V1::CooperationRegularFeedbacks", type: :request do

  let!(:login_user) { create(:user) }
  let!(:school) { create(:school, user: login_user) }
  let!(:teacher) {create(:teacher, user: login_user, school: school)}
  let!(:project1) { create(:project) }
  let!(:project2) { create(:project) }
  let!(:project3) { create(:project) }
  let!(:feedback1) {create(:feedback, type: 'ContinualFeedback', owner: project2, school: login_user.school, content: '项目帮助贫困学生', user: login_user, project: project2)}
  let!(:feedback2) {create(:feedback, type: 'ContinualFeedback', owner: project2, school: login_user.school, content: '项目帮助贫困学生', user: login_user, project: project2)}
  let!(:feedback3) {create(:feedback, type: 'ContinualFeedback', owner: project2, school: login_user.school, content: '项目帮助贫困学生', user: login_user, project: project2)}

  describe '定期反馈' do
    it '获取项目列表' do
      get api_v1_cooperation_regular_feedbacks_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:projects].count) === 3
    end

    it '提交反馈' do
      post api_v1_cooperation_regular_feedbacks_path,
          params: {
              project_id: project1.id,
              content: '项目帮助贫困学生'
          }, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data]).to be true
    end

    it '获取反馈列表' do
      get feedback_list_api_v1_cooperation_regular_feedbacks_path(project_id: project2.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:feedbacks].count) === 3
    end

    it '获取二维码地址' do
      get qrcode_api_v1_cooperation_regular_feedbacks_path(project_id: project1.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '获取信息' do
      get get_info_api_v1_cooperation_regular_feedbacks_path(project_id: project1.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end
  end

end
