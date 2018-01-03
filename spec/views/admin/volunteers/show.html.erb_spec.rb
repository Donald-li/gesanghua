require 'rails_helper'

RSpec.describe "admin/volunteers/show", type: :view do
  before(:each) do
    @admin_volunteer = assign(:admin_volunteer, Admin::Volunteer.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
