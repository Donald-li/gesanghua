require 'rails_helper'

RSpec.describe "admin/task_applies/index", type: :view do
  before(:each) do
    assign(:admin_task_applies, [
      Admin::TaskApply.create!(),
      Admin::TaskApply.create!()
    ])
  end

  it "renders a list of admin/task_applies" do
    render
  end
end
