require 'rails_helper'

RSpec.describe "Admin::AppointTasks", type: :request do
  describe "GET /admin_appoint_tasks" do
    it "works! (now write some real specs)" do
      get admin_appoint_tasks_path
      expect(response).to have_http_status(200)
    end
  end
end
