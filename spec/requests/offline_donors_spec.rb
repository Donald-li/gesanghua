require 'rails_helper'

RSpec.describe "Api::V1::OfflineDonors", type: :request do

   let!(:user) { create(:user) }
   let!(:donor1) { create(:offline_donor, user: user) }
   let!(:donor2) { create(:offline_donor, user: user) }
   let!(:donor3) { create(:offline_donor, user: user) }

  describe '代捐人列表' do
    it '获取代捐人列表' do
      get donor_list_api_v1_offline_donors_path
      api_v1_expect_success
      expect(json_body[:data].first[:name]).to eq donor1.name
    end
  end

end
