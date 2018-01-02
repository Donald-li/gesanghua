require 'rails_helper'

RSpec.describe "admin/pair_applies/show", type: :view do
  before(:each) do
    @admin_pair_apply = assign(:admin_pair_apply, Admin::PairApply.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
