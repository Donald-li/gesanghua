require 'rails_helper'

RSpec.describe "admin/complaints/show", type: :view do
  before(:each) do
    @admin_complaint = assign(:admin_complaint, Admin::Complaint.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
