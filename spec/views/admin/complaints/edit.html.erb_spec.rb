require 'rails_helper'

RSpec.describe "admin/complaints/edit", type: :view do
  before(:each) do
    @admin_complaint = assign(:admin_complaint, Admin::Complaint.create!())
  end

  it "renders the edit admin_complaint form" do
    render

    assert_select "form[action=?][method=?]", admin_complaint_path(@admin_complaint), "post" do
    end
  end
end
