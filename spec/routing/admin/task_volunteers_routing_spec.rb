require "rails_helper"

RSpec.describe Admin::TaskVolunteersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/task_volunteers").to route_to("admin/task_volunteers#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/task_volunteers/new").to route_to("admin/task_volunteers#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/task_volunteers/1").to route_to("admin/task_volunteers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/task_volunteers/1/edit").to route_to("admin/task_volunteers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/task_volunteers").to route_to("admin/task_volunteers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/task_volunteers/1").to route_to("admin/task_volunteers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/task_volunteers/1").to route_to("admin/task_volunteers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/task_volunteers/1").to route_to("admin/task_volunteers#destroy", :id => "1")
    end

  end
end
