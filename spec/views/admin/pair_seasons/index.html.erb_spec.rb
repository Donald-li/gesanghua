require 'rails_helper'

RSpec.describe "admin/pairs/index", type: :view do
  before(:each) do
    assign(:admin_pairs, [
      Admin::Pair.create!(),
      Admin::Pair.create!()
    ])
  end

  it "renders a list of admin/pairs" do
    render
  end
end
