require 'rails_helper'

RSpec.describe "admin/task_achievements/new", type: :view do
  before(:each) do
    assign(:admin_task_achievement, Admin::TaskAchievement.new())
  end

  it "renders new admin_task_achievement form" do
    render

    assert_select "form[action=?][method=?]", admin_task_achievements_path, "post" do
    end
  end
end
