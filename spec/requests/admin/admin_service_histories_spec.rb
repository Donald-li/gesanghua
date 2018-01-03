require 'rails_helper'

RSpec.describe "Admin::ServiceHistories", type: :request do
  describe "GET /admin_service_histories" do
    it "works! (now write some real specs)" do
      get admin_service_histories_path
      expect(response).to have_http_status(200)
    end
  end
end
