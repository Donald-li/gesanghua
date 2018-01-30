require 'rails_helper'

RSpec.describe "Admin::RadioDonateRecords", type: :request do
  describe "GET /admin_radio_donate_records" do
    it "works! (now write some real specs)" do
      get admin_radio_donate_records_path
      expect(response).to have_http_status(200)
    end
  end
end
