require 'rails_helper'

RSpec.describe "admin/volunteers/index", type: :view do
  before(:each) do
    assign(:admin_volunteers, [
      Admin::Volunteer.create!(),
      Admin::Volunteer.create!()
    ])
  end

  it "renders a list of admin/volunteers" do
    render
  end
end
