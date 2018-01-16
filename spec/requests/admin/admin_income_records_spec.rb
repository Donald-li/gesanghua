require 'rails_helper'

RSpec.describe "Admin::IncomeRecords", type: :request do
  describe "GET /admin_income_records" do
    it "works! (now write some real specs)" do
      get admin_income_records_path
      expect(response).to have_http_status(200)
    end
  end
end
