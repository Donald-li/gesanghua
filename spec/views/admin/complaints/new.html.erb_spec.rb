require 'rails_helper'

RSpec.describe "admin/complaints/new", type: :view do
  before(:each) do
    assign(:admin_complaint, Admin::Complaint.new())
  end

  it "renders new admin_complaint form" do
    render

    assert_select "form[action=?][method=?]", admin_complaints_path, "post" do
    end
  end
end
