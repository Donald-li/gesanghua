require 'rails_helper'

RSpec.describe "admin/task_volunteers/new", type: :view do
  before(:each) do
    assign(:admin_task_volunteer, Admin::TaskVolunteer.new())
  end

  it "renders new admin_task_volunteer form" do
    render

    assert_select "form[action=?][method=?]", admin_task_volunteers_path, "post" do
    end
  end
end
