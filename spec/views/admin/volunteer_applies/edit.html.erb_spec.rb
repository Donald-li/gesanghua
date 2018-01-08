require 'rails_helper'

RSpec.describe "admin/volunteer_applies/edit", type: :view do
  before(:each) do
    @admin_volunteer_apply = assign(:admin_volunteer_apply, Admin::VolunteerApply.create!())
  end

  it "renders the edit admin_volunteer_apply form" do
    render

    assert_select "form[action=?][method=?]", admin_volunteer_apply_path(@admin_volunteer_apply), "post" do
    end
  end
end
