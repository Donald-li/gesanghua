require 'rails_helper'

RSpec.describe "admin/appoint_tasks/edit", type: :view do
  before(:each) do
    @admin_appoint_task = assign(:admin_appoint_task, Admin::AppointTask.create!())
  end

  it "renders the edit admin_appoint_task form" do
    render

    assert_select "form[action=?][method=?]", admin_appoint_task_path(@admin_appoint_task), "post" do
    end
  end
end
