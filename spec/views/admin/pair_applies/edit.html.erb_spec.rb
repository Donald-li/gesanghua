require 'rails_helper'

RSpec.describe "admin/pair_applies/edit", type: :view do
  before(:each) do
    @admin_pair_apply = assign(:admin_pair_apply, Admin::PairApply.create!())
  end

  it "renders the edit admin_pair_apply form" do
    render

    assert_select "form[action=?][method=?]", admin_pair_apply_path(@admin_pair_apply), "post" do
    end
  end
end
