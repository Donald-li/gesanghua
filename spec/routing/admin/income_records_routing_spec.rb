require "rails_helper"

RSpec.describe Admin::IncomeRecordsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/income_records").to route_to("admin/income_records#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/income_records/new").to route_to("admin/income_records#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/income_records/1").to route_to("admin/income_records#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/income_records/1/edit").to route_to("admin/income_records#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/income_records").to route_to("admin/income_records#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/income_records/1").to route_to("admin/income_records#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/income_records/1").to route_to("admin/income_records#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/income_records/1").to route_to("admin/income_records#destroy", :id => "1")
    end

  end
end
