require 'rails_helper'

RSpec.describe "admin/pair_applies/index", type: :view do
  before(:each) do
    assign(:admin_pair_applies, [
      Admin::PairApply.create!(),
      Admin::PairApply.create!()
    ])
  end

  it "renders a list of admin/pair_applies" do
    render
  end
end
