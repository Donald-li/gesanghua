require 'rails_helper'

RSpec.describe "Admin::PairApplies", type: :request do
  describe "GET /admin_pair_applies" do
    it "works! (now write some real specs)" do
      get admin_pair_applies_path
      expect(response).to have_http_status(200)
    end
  end
end
