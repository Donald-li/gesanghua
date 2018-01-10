require 'rails_helper'

RSpec.describe "admin/task_applies/new", type: :view do
  before(:each) do
    assign(:admin_task_apply, Admin::TaskApply.new())
  end

  it "renders new admin_task_apply form" do
    render

    assert_select "form[action=?][method=?]", admin_task_applies_path, "post" do
    end
  end
end
