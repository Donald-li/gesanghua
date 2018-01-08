require 'rails_helper'

RSpec.describe "admin/volunteer_applies/show", type: :view do
  before(:each) do
    @admin_volunteer_apply = assign(:admin_volunteer_apply, Admin::VolunteerApply.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
