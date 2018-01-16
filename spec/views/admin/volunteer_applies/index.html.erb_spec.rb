require 'rails_helper'

RSpec.describe "admin/volunteer_applies/index", type: :view do
  before(:each) do
    assign(:admin_volunteer_applies, [
      Admin::VolunteerApply.create!(),
      Admin::VolunteerApply.create!()
    ])
  end

  it "renders a list of admin/volunteer_applies" do
    render
  end
end
