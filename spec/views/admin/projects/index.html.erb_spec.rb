require 'rails_helper'

RSpec.describe "admin/project_templates/index", type: :view do
  before(:each) do
    assign(:admin_project_templates, [
      Admin::ProjectTemplate.create!(),
      Admin::ProjectTemplate.create!()
    ])
  end

  it "renders a list of admin/project_templates" do
    render
  end
end
