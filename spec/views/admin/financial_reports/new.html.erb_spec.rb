require 'rails_helper'

RSpec.describe "admin/financial_reports/new", type: :view do
  before(:each) do
    assign(:admin_financial_report, Admin::FinancialReport.new())
  end

  it "renders new admin_financial_report form" do
    render

    assert_select "form[action=?][method=?]", admin_financial_reports_path, "post" do
    end
  end
end
