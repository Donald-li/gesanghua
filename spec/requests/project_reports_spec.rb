require 'rails_helper'

RSpec.describe "Api::V1::ProjectReports", type: :request do
  describe '项目报告' do
    let(:project) { create(:project, :with_project_reports) }

    it '获取结对报告列表' do
      get api_v1_project_reports_path(project_id: project.id)
      api_v1_expect_success
      # expect_json({ data: { reports: [{id: 1}] }})
    end

  end
end