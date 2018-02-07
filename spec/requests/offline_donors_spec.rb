require 'rails_helper'

RSpec.describe "Api::V1::OfflineDonors", type: :request do

  let!(:login_user) {create(:user)}
  let!(:donor1) {create(:user, manager: login_user)}
  let!(:donor2) {create(:user, manager: login_user)}
  let!(:donor3) {create(:user, manager: login_user)}

  describe '代捐人列表' do
    it '获取代捐人列表' do
      get donor_list_api_v1_offline_donors_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end
  end

end
