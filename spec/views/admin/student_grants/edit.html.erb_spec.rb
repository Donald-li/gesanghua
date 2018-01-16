require 'rails_helper'

RSpec.describe "admin/pair_child_grants/edit", type: :view do
  before(:each) do
    @admin_pair_child_grant = assign(:admin_pair_child_grant, Admin::PairChildGrant.create!())
  end

  it "renders the edit admin_pair_child_grant form" do
    render

    assert_select "form[action=?][method=?]", admin_pair_child_grant_path(@admin_pair_child_grant), "post" do
    end
  end
end
