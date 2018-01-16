require 'rails_helper'

RSpec.describe "admin/tasks/new", type: :view do
  before(:each) do
    assign(:admin_task, Admin::Task.new())
  end

  it "renders new admin_task form" do
    render

    assert_select "form[action=?][method=?]", admin_tasks_path, "post" do
    end
  end
end
