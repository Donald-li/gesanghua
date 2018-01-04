require "rails_helper"

RSpec.describe Admin::SpecialAdvertsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/special_adverts").to route_to("admin/special_adverts#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/special_adverts/new").to route_to("admin/special_adverts#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/special_adverts/1").to route_to("admin/special_adverts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/special_adverts/1/edit").to route_to("admin/special_adverts#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/special_adverts").to route_to("admin/special_adverts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/special_adverts/1").to route_to("admin/special_adverts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/special_adverts/1").to route_to("admin/special_adverts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/special_adverts/1").to route_to("admin/special_adverts#destroy", :id => "1")
    end

  end
end
