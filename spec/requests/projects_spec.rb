require 'rails_helper'

RSpec.describe "Api::V1::Projects", type: :request do

  let!(:login_user) { create(:user) }

  describe '项目介绍' do
    it '结对助学项目介绍' do
      pair = create(:project, name: '结对助学', alias: 'pair')
      get description_api_v1_projects_path(name: pair.alias), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect_json({ data: {name: '结对助学'} })
    end
  end

end
