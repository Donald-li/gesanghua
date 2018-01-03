require "rails_helper"

RSpec.describe Admin::ServiceHistoriesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/service_histories").to route_to("admin/service_histories#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/service_histories/new").to route_to("admin/service_histories#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/service_histories/1").to route_to("admin/service_histories#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/service_histories/1/edit").to route_to("admin/service_histories#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/service_histories").to route_to("admin/service_histories#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/service_histories/1").to route_to("admin/service_histories#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/service_histories/1").to route_to("admin/service_histories#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/service_histories/1").to route_to("admin/service_histories#destroy", :id => "1")
    end

  end
end
