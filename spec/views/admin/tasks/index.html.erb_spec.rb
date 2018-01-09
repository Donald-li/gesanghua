require 'rails_helper'

RSpec.describe "admin/tasks/index", type: :view do
  before(:each) do
    assign(:admin_tasks, [
      Admin::Task.create!(),
      Admin::Task.create!()
    ])
  end

  it "renders a list of admin/tasks" do
    render
  end
end
