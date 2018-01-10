require 'rails_helper'

RSpec.describe "Admin::TaskVolunteers", type: :request do
  describe "GET /admin_task_volunteers" do
    it "works! (now write some real specs)" do
      get admin_task_volunteers_path
      expect(response).to have_http_status(200)
    end
  end
end
