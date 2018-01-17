require 'rails_helper'

RSpec.describe "Api::V1::Projects", type: :request do
  describe '任务成果' do
    let(:project) { create(:project) }
    it '结对项目介绍' do
      get api_v1_project_path(project)
      api_v1_expect_success
      expect_json({ data: {name: '结对'} })
    end
  end
end
