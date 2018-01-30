require 'rails_helper'

RSpec.describe "Admin::BeneficialChildren", type: :request do
  describe "GET /admin_beneficial_children" do
    it "works! (now write some real specs)" do
      get admin_beneficial_children_path
      expect(response).to have_http_status(200)
    end
  end
end
