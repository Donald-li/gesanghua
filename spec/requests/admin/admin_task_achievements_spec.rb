require 'rails_helper'

RSpec.describe "Admin::TaskAchievements", type: :request do
  describe "GET /admin_task_achievements" do
    it "works! (now write some real specs)" do
      get admin_task_achievements_path
      expect(response).to have_http_status(200)
    end
  end
end
