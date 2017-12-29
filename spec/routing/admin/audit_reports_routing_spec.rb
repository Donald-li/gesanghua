require "rails_helper"

RSpec.describe Admin::AuditReportsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/audit_reports").to route_to("admin/audit_reports#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/audit_reports/new").to route_to("admin/audit_reports#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/audit_reports/1").to route_to("admin/audit_reports#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/audit_reports/1/edit").to route_to("admin/audit_reports#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/audit_reports").to route_to("admin/audit_reports#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/audit_reports/1").to route_to("admin/audit_reports#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/audit_reports/1").to route_to("admin/audit_reports#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/audit_reports/1").to route_to("admin/audit_reports#destroy", :id => "1")
    end

  end
end
