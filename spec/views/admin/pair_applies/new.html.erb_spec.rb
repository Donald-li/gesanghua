require 'rails_helper'

RSpec.describe "admin/pair_applies/new", type: :view do
  before(:each) do
    assign(:admin_pair_apply, Admin::PairApply.new())
  end

  it "renders new admin_pair_apply form" do
    render

    assert_select "form[action=?][method=?]", admin_pair_applies_path, "post" do
    end
  end
end
