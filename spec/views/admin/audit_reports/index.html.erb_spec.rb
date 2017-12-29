require 'rails_helper'

RSpec.describe "admin/audit_reports/index", type: :view do
  before(:each) do
    assign(:admin_audit_reports, [
      Admin::AuditReport.create!(),
      Admin::AuditReport.create!()
    ])
  end

  it "renders a list of admin/audit_reports" do
    render
  end
end
