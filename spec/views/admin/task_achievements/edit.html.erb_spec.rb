require 'rails_helper'

RSpec.describe "admin/task_achievements/edit", type: :view do
  before(:each) do
    @admin_task_achievement = assign(:admin_task_achievement, Admin::TaskAchievement.create!())
  end

  it "renders the edit admin_task_achievement form" do
    render

    assert_select "form[action=?][method=?]", admin_task_achievement_path(@admin_task_achievement), "post" do
    end
  end
end
