require 'rails_helper'

RSpec.describe "admin/pair_lists/show", type: :view do
  before(:each) do
    @admin_pair_list = assign(:admin_pair_list, Admin::PairList.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
