require 'rails_helper'

RSpec.describe "admin/task_achievements/index", type: :view do
  before(:each) do
    assign(:admin_task_achievements, [
      Admin::TaskAchievement.create!(),
      Admin::TaskAchievement.create!()
    ])
  end

  it "renders a list of admin/task_achievements" do
    render
  end
end
