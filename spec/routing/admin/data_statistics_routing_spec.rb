require "rails_helper"

RSpec.describe Admin::DataStatisticsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/data_statistics").to route_to("admin/data_statistics#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/data_statistics/new").to route_to("admin/data_statistics#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/data_statistics/1").to route_to("admin/data_statistics#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/data_statistics/1/edit").to route_to("admin/data_statistics#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/data_statistics").to route_to("admin/data_statistics#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/data_statistics/1").to route_to("admin/data_statistics#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/data_statistics/1").to route_to("admin/data_statistics#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/data_statistics/1").to route_to("admin/data_statistics#destroy", :id => "1")
    end

  end
end
