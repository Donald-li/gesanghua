require "rails_helper"

RSpec.describe Admin::ComplaintsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/complaints").to route_to("admin/complaints#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/complaints/new").to route_to("admin/complaints#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/complaints/1").to route_to("admin/complaints#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/complaints/1/edit").to route_to("admin/complaints#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/complaints").to route_to("admin/complaints#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/complaints/1").to route_to("admin/complaints#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/complaints/1").to route_to("admin/complaints#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/complaints/1").to route_to("admin/complaints#destroy", :id => "1")
    end

  end
end
