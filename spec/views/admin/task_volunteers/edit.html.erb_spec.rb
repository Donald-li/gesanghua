require 'rails_helper'

RSpec.describe "admin/task_volunteers/edit", type: :view do
  before(:each) do
    @admin_task_volunteer = assign(:admin_task_volunteer, Admin::TaskVolunteer.create!())
  end

  it "renders the edit admin_task_volunteer form" do
    render

    assert_select "form[action=?][method=?]", admin_task_volunteer_path(@admin_task_volunteer), "post" do
    end
  end
end
