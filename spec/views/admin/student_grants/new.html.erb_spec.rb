require 'rails_helper'

RSpec.describe "admin/pair_child_grants/new", type: :view do
  before(:each) do
    assign(:admin_pair_child_grant, Admin::PairChildGrant.new())
  end

  it "renders new admin_pair_child_grant form" do
    render

    assert_select "form[action=?][method=?]", admin_pair_child_grants_path, "post" do
    end
  end
end
