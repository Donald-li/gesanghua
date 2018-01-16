require 'rails_helper'

RSpec.describe "admin/pair_child_grants/show", type: :view do
  before(:each) do
    @admin_pair_child_grant = assign(:admin_pair_child_grant, Admin::PairChildGrant.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
