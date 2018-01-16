require 'rails_helper'

RSpec.describe "admin/pair_child_grants/index", type: :view do
  before(:each) do
    assign(:admin_pair_child_grants, [
      Admin::PairChildGrant.create!(),
      Admin::PairChildGrant.create!()
    ])
  end

  it "renders a list of admin/pair_child_grants" do
    render
  end
end
