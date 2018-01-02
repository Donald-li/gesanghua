require "rails_helper"

RSpec.describe Admin::PairAppliesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/pair_applies").to route_to("admin/pair_applies#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/pair_applies/new").to route_to("admin/pair_applies#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/pair_applies/1").to route_to("admin/pair_applies#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/pair_applies/1/edit").to route_to("admin/pair_applies#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/pair_applies").to route_to("admin/pair_applies#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/pair_applies/1").to route_to("admin/pair_applies#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/pair_applies/1").to route_to("admin/pair_applies#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/pair_applies/1").to route_to("admin/pair_applies#destroy", :id => "1")
    end

  end
end
