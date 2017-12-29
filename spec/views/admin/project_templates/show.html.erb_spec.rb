require 'rails_helper'

RSpec.describe "admin/project_templates/show", type: :view do
  before(:each) do
    @admin_project_template = assign(:admin_project_template, Admin::ProjectTemplate.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
