require 'rails_helper'

RSpec.describe "admin/complaints/index", type: :view do
  before(:each) do
    assign(:admin_complaints, [
      Admin::Complaint.create!(),
      Admin::Complaint.create!()
    ])
  end

  it "renders a list of admin/complaints" do
    render
  end
end
