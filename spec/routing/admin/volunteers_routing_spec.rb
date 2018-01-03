require "rails_helper"

RSpec.describe Admin::VolunteersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/volunteers").to route_to("admin/volunteers#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/volunteers/new").to route_to("admin/volunteers#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/volunteers/1").to route_to("admin/volunteers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/volunteers/1/edit").to route_to("admin/volunteers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/volunteers").to route_to("admin/volunteers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/volunteers/1").to route_to("admin/volunteers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/volunteers/1").to route_to("admin/volunteers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/volunteers/1").to route_to("admin/volunteers#destroy", :id => "1")
    end

  end
end
