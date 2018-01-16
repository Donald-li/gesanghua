require 'rails_helper'

RSpec.describe "admin/pairs/new", type: :view do
  before(:each) do
    assign(:admin_pair, Admin::Pair.new())
  end

  it "renders new admin_pair form" do
    render

    assert_select "form[action=?][method=?]", admin_pairs_path, "post" do
    end
  end
end
