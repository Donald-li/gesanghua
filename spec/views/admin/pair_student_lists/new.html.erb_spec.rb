require 'rails_helper'

RSpec.describe "admin/pair_lists/new", type: :view do
  before(:each) do
    assign(:admin_pair_list, Admin::PairList.new())
  end

  it "renders new admin_pair_list form" do
    render

    assert_select "form[action=?][method=?]", admin_pair_lists_path, "post" do
    end
  end
end
