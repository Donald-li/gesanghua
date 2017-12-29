require 'rails_helper'

RSpec.describe "admin/audit_reports/show", type: :view do
  before(:each) do
    @admin_audit_report = assign(:admin_audit_report, Admin::AuditReport.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
