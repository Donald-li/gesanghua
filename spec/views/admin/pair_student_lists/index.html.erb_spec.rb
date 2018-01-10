require 'rails_helper'

RSpec.describe "admin/pair_lists/index", type: :view do
  before(:each) do
    assign(:admin_pair_lists, [
      Admin::PairList.create!(),
      Admin::PairList.create!()
    ])
  end

  it "renders a list of admin/pair_lists" do
    render
  end
end
