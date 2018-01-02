require 'rails_helper'

RSpec.describe "admin/financial_reports/index", type: :view do
  before(:each) do
    assign(:admin_financial_reports, [
      Admin::FinancialReport.create!(),
      Admin::FinancialReport.create!()
    ])
  end

  it "renders a list of admin/financial_reports" do
    render
  end
end
