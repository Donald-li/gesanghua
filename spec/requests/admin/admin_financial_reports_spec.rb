require 'rails_helper'

RSpec.describe "Admin::FinancialReports", type: :request do
  describe "GET /admin_financial_reports" do
    it "works! (now write some real specs)" do
      get admin_financial_reports_path
      expect(response).to have_http_status(200)
    end
  end
end
