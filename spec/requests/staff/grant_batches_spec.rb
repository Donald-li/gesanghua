require 'rails_helper'

RSpec.describe "Api::V1::Staff::GrantBatches", type: :request do

  let!(:login_user) { create(:user) }
  let!(:batch){ create(:grant_batch, project: Project.pair_project)}

  describe '结对助学发放批次' do
    it '批次列表' do
      get api_v1_staff_grant_batches_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:grant_batches].first[:projectId]).to eq 1
    end
  end

end
