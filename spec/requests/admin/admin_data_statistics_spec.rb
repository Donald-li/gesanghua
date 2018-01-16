require 'rails_helper'

RSpec.describe "Admin::DataStatistics", type: :request do
  describe "GET /admin_data_statistics" do
    it "works! (now write some real specs)" do
      get admin_data_statistics_path
      expect(response).to have_http_status(200)
    end
  end
end
