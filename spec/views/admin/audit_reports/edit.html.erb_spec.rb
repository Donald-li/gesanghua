require 'rails_helper'

RSpec.describe "admin/audit_reports/edit", type: :view do
  before(:each) do
    @admin_audit_report = assign(:admin_audit_report, Admin::AuditReport.create!())
  end

  it "renders the edit admin_audit_report form" do
    render

    assert_select "form[action=?][method=?]", admin_audit_report_path(@admin_audit_report), "post" do
    end
  end
end
