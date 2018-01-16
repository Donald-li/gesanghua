require 'rails_helper'

RSpec.describe "admin/volunteer_applies/new", type: :view do
  before(:each) do
    assign(:admin_volunteer_apply, Admin::VolunteerApply.new())
  end

  it "renders new admin_volunteer_apply form" do
    render

    assert_select "form[action=?][method=?]", admin_volunteer_applies_path, "post" do
    end
  end
end
