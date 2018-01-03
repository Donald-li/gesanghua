require 'rails_helper'

RSpec.describe "admin/volunteers/edit", type: :view do
  before(:each) do
    @admin_volunteer = assign(:admin_volunteer, Admin::Volunteer.create!())
  end

  it "renders the edit admin_volunteer form" do
    render

    assert_select "form[action=?][method=?]", admin_volunteer_path(@admin_volunteer), "post" do
    end
  end
end
