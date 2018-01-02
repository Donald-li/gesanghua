require 'rails_helper'

RSpec.describe "admin/pairs/edit", type: :view do
  before(:each) do
    @admin_pair = assign(:admin_pair, Admin::Pair.create!())
  end

  it "renders the edit admin_pair form" do
    render

    assert_select "form[action=?][method=?]", admin_pair_path(@admin_pair), "post" do
    end
  end
end
