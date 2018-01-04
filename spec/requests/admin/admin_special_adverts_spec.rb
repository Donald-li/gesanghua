require 'rails_helper'

RSpec.describe "Admin::SpecialAdverts", type: :request do
  describe "GET /admin_special_adverts" do
    it "works! (now write some real specs)" do
      get admin_special_adverts_path
      expect(response).to have_http_status(200)
    end
  end
end
