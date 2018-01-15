require 'rails_helper'

RSpec.describe "Admin::DonateStatistics", type: :request do
  describe "GET /admin_donate_statistics" do
    it "works! (now write some real specs)" do
      get admin_donate_statistics_path
      expect(response).to have_http_status(200)
    end
  end
end
