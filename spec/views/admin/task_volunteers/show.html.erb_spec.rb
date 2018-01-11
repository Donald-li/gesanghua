require 'rails_helper'

RSpec.describe "admin/task_volunteers/show", type: :view do
  before(:each) do
    @admin_task_volunteer = assign(:admin_task_volunteer, Admin::TaskVolunteer.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
