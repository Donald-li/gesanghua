require "rails_helper"

RSpec.describe Admin::TaskAppliesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/task_applies").to route_to("admin/task_applies#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/task_applies/new").to route_to("admin/task_applies#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/task_applies/1").to route_to("admin/task_applies#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/task_applies/1/edit").to route_to("admin/task_applies#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/task_applies").to route_to("admin/task_applies#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/task_applies/1").to route_to("admin/task_applies#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/task_applies/1").to route_to("admin/task_applies#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/task_applies/1").to route_to("admin/task_applies#destroy", :id => "1")
    end

  end
end
