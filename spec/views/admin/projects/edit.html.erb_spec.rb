require 'rails_helper'

RSpec.describe "admin/project_templates/edit", type: :view do
  before(:each) do
    @admin_project_template = assign(:admin_project_template, Admin::ProjectTemplate.create!())
  end

  it "renders the edit admin_project_template form" do
    render

    assert_select "form[action=?][method=?]", admin_project_template_path(@admin_project_template), "post" do
    end
  end
end
