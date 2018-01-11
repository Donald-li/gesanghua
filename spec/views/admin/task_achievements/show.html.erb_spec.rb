require 'rails_helper'

RSpec.describe "admin/task_achievements/show", type: :view do
  before(:each) do
    @admin_task_achievement = assign(:admin_task_achievement, Admin::TaskAchievement.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
