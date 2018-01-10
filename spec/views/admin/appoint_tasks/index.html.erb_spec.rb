require 'rails_helper'

RSpec.describe "admin/appoint_tasks/index", type: :view do
  before(:each) do
    assign(:admin_appoint_tasks, [
      Admin::AppointTask.create!(),
      Admin::AppointTask.create!()
    ])
  end

  it "renders a list of admin/appoint_tasks" do
    render
  end
end
