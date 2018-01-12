require "rails_helper"

RSpec.describe Admin::StudentGrantsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/pair_child_grants").to route_to("admin/pair_child_grants#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/pair_child_grants/new").to route_to("admin/pair_child_grants#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/pair_child_grants/1").to route_to("admin/pair_child_grants#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/pair_child_grants/1/edit").to route_to("admin/pair_child_grants#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/pair_child_grants").to route_to("admin/pair_child_grants#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/pair_child_grants/1").to route_to("admin/pair_child_grants#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/pair_child_grants/1").to route_to("admin/pair_child_grants#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/pair_child_grants/1").to route_to("admin/pair_child_grants#destroy", :id => "1")
    end

  end
end
