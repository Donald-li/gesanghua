require "rails_helper"

RSpec.describe Admin::ProjectsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/project_templates").to route_to("admin/project_templates#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/project_templates/new").to route_to("admin/project_templates#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/project_templates/1").to route_to("admin/project_templates#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/project_templates/1/edit").to route_to("admin/project_templates#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/project_templates").to route_to("admin/project_templates#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/project_templates/1").to route_to("admin/project_templates#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/project_templates/1").to route_to("admin/project_templates#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/project_templates/1").to route_to("admin/project_templates#destroy", :id => "1")
    end

  end
end
