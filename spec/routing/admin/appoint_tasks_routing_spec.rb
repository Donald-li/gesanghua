require "rails_helper"

RSpec.describe Admin::AppointTasksController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/appoint_tasks").to route_to("admin/appoint_tasks#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/appoint_tasks/new").to route_to("admin/appoint_tasks#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/appoint_tasks/1").to route_to("admin/appoint_tasks#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/appoint_tasks/1/edit").to route_to("admin/appoint_tasks#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/appoint_tasks").to route_to("admin/appoint_tasks#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/appoint_tasks/1").to route_to("admin/appoint_tasks#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/appoint_tasks/1").to route_to("admin/appoint_tasks#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/appoint_tasks/1").to route_to("admin/appoint_tasks#destroy", :id => "1")
    end

  end
end
