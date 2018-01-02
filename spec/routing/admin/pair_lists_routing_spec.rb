require "rails_helper"

RSpec.describe Admin::PairListsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/pair_lists").to route_to("admin/pair_lists#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/pair_lists/new").to route_to("admin/pair_lists#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/pair_lists/1").to route_to("admin/pair_lists#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/pair_lists/1/edit").to route_to("admin/pair_lists#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/pair_lists").to route_to("admin/pair_lists#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/pair_lists/1").to route_to("admin/pair_lists#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/pair_lists/1").to route_to("admin/pair_lists#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/pair_lists/1").to route_to("admin/pair_lists#destroy", :id => "1")
    end

  end
end
