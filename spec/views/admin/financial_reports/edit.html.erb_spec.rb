require 'rails_helper'

RSpec.describe "admin/financial_reports/edit", type: :view do
  before(:each) do
    @admin_financial_report = assign(:admin_financial_report, Admin::FinancialReport.create!())
  end

  it "renders the edit admin_financial_report form" do
    render

    assert_select "form[action=?][method=?]", admin_financial_report_path(@admin_financial_report), "post" do
    end
  end
end
