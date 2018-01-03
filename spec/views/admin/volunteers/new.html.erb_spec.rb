require 'rails_helper'

RSpec.describe "admin/volunteers/new", type: :view do
  before(:each) do
    assign(:admin_volunteer, Admin::Volunteer.new())
  end

  it "renders new admin_volunteer form" do
    render

    assert_select "form[action=?][method=?]", admin_volunteers_path, "post" do
    end
  end
end
