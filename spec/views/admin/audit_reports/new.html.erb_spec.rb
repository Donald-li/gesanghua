require 'rails_helper'

RSpec.describe "admin/audit_reports/new", type: :view do
  before(:each) do
    assign(:admin_audit_report, Admin::AuditReport.new())
  end

  it "renders new admin_audit_report form" do
    render

    assert_select "form[action=?][method=?]", admin_audit_reports_path, "post" do
    end
  end
end
