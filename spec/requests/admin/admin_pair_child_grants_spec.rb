require 'rails_helper'

RSpec.describe "Admin::PairChildGrants", type: :request do
  describe "GET /admin_pair_child_grants" do
    it "works! (now write some real specs)" do
      get admin_pair_child_grants_path
      expect(response).to have_http_status(200)
    end
  end
end
