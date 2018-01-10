require 'rails_helper'

RSpec.describe "Admin::VolunteerApplies", type: :request do
  describe "GET /admin_volunteer_applies" do
    it "works! (now write some real specs)" do
      get admin_volunteer_applies_path
      expect(response).to have_http_status(200)
    end
  end
end
