require 'rails_helper'

RSpec.describe "admin/task_volunteers/index", type: :view do
  before(:each) do
    assign(:admin_task_volunteers, [
      Admin::TaskVolunteer.create!(),
      Admin::TaskVolunteer.create!()
    ])
  end

  it "renders a list of admin/task_volunteers" do
    render
  end
end
