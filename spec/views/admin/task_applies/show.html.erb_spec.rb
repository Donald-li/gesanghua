require 'rails_helper'

RSpec.describe "admin/task_applies/show", type: :view do
  before(:each) do
    @admin_task_apply = assign(:admin_task_apply, Admin::TaskApply.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
