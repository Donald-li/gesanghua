require 'rails_helper'

RSpec.describe "Admin::PairLists", type: :request do
  describe "GET /admin_pair_lists" do
    it "works! (now write some real specs)" do
      get admin_pair_lists_path
      expect(response).to have_http_status(200)
    end
  end
end
