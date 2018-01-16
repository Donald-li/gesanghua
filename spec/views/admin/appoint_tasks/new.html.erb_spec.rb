require 'rails_helper'

RSpec.describe "admin/appoint_tasks/new", type: :view do
  before(:each) do
    assign(:admin_appoint_task, Admin::AppointTask.new())
  end

  it "renders new admin_appoint_task form" do
    render

    assert_select "form[action=?][method=?]", admin_appoint_tasks_path, "post" do
    end
  end
end
