require 'rails_helper'

RSpec.describe "Admin::Pairs", type: :request do
  describe "GET /admin_pairs" do
    it "works! (now write some real specs)" do
      get admin_pairs_path
      expect(response).to have_http_status(200)
    end
  end
end
