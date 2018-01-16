require "rails_helper"

RSpec.describe Admin::DonateStatisticsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/donate_statistics").to route_to("admin/donate_statistics#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/donate_statistics/new").to route_to("admin/donate_statistics#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/donate_statistics/1").to route_to("admin/donate_statistics#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/donate_statistics/1/edit").to route_to("admin/donate_statistics#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/donate_statistics").to route_to("admin/donate_statistics#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/donate_statistics/1").to route_to("admin/donate_statistics#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/donate_statistics/1").to route_to("admin/donate_statistics#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/donate_statistics/1").to route_to("admin/donate_statistics#destroy", :id => "1")
    end

  end
end
