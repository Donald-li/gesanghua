require "rails_helper"

RSpec.describe Admin::SpecialArticlesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/special_articles").to route_to("admin/special_articles#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/special_articles/new").to route_to("admin/special_articles#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/special_articles/1").to route_to("admin/special_articles#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/special_articles/1/edit").to route_to("admin/special_articles#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/special_articles").to route_to("admin/special_articles#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/special_articles/1").to route_to("admin/special_articles#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/special_articles/1").to route_to("admin/special_articles#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/special_articles/1").to route_to("admin/special_articles#destroy", :id => "1")
    end

  end
end
