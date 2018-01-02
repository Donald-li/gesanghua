require 'rails_helper'

RSpec.describe "admin/financial_reports/show", type: :view do
  before(:each) do
    @admin_financial_report = assign(:admin_financial_report, Admin::FinancialReport.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
