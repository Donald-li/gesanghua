require "rails_helper"

RSpec.describe Admin::PairsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/pairs").to route_to("admin/pairs#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/pairs/new").to route_to("admin/pairs#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/pairs/1").to route_to("admin/pairs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/pairs/1/edit").to route_to("admin/pairs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/pairs").to route_to("admin/pairs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/pairs/1").to route_to("admin/pairs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/pairs/1").to route_to("admin/pairs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/pairs/1").to route_to("admin/pairs#destroy", :id => "1")
    end

  end
end
