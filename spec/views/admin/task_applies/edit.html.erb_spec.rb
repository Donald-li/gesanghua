require 'rails_helper'

RSpec.describe "admin/task_applies/edit", type: :view do
  before(:each) do
    @admin_task_apply = assign(:admin_task_apply, Admin::TaskApply.create!())
  end

  it "renders the edit admin_task_apply form" do
    render

    assert_select "form[action=?][method=?]", admin_task_apply_path(@admin_task_apply), "post" do
    end
  end
end
