require 'rails_helper'

RSpec.describe "Admin::TaskApplies", type: :request do
  describe "GET /admin_task_applies" do
    it "works! (now write some real specs)" do
      get admin_task_applies_path
      expect(response).to have_http_status(200)
    end
  end
end
