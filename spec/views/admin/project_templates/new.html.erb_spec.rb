require 'rails_helper'

RSpec.describe "admin/project_templates/new", type: :view do
  before(:each) do
    assign(:admin_project_template, Admin::ProjectTemplate.new())
  end

  it "renders new admin_project_template form" do
    render

    assert_select "form[action=?][method=?]", admin_project_templates_path, "post" do
    end
  end
end
