require "rails_helper"

RSpec.describe Admin::TaskAchievementsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/task_achievements").to route_to("admin/task_achievements#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/task_achievements/new").to route_to("admin/task_achievements#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/task_achievements/1").to route_to("admin/task_achievements#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/task_achievements/1/edit").to route_to("admin/task_achievements#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/task_achievements").to route_to("admin/task_achievements#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/task_achievements/1").to route_to("admin/task_achievements#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/task_achievements/1").to route_to("admin/task_achievements#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/task_achievements/1").to route_to("admin/task_achievements#destroy", :id => "1")
    end

  end
end
