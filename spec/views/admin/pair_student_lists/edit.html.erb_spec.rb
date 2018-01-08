require 'rails_helper'

RSpec.describe "admin/pair_lists/edit", type: :view do
  before(:each) do
    @admin_pair_list = assign(:admin_pair_list, Admin::PairList.create!())
  end

  it "renders the edit admin_pair_list form" do
    render

    assert_select "form[action=?][method=?]", admin_pair_list_path(@admin_pair_list), "post" do
    end
  end
end
