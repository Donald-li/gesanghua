require 'rails_helper'

RSpec.describe "admin/appoint_tasks/show", type: :view do
  before(:each) do
    @admin_appoint_task = assign(:admin_appoint_task, Admin::AppointTask.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
