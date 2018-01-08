require "rails_helper"

RSpec.describe Admin::VolunteerAppliesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/volunteer_applies").to route_to("admin/volunteer_applies#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/volunteer_applies/new").to route_to("admin/volunteer_applies#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/volunteer_applies/1").to route_to("admin/volunteer_applies#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/volunteer_applies/1/edit").to route_to("admin/volunteer_applies#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/volunteer_applies").to route_to("admin/volunteer_applies#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/volunteer_applies/1").to route_to("admin/volunteer_applies#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/volunteer_applies/1").to route_to("admin/volunteer_applies#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/volunteer_applies/1").to route_to("admin/volunteer_applies#destroy", :id => "1")
    end

  end
end
