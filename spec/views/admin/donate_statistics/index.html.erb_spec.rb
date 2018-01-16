require 'rails_helper'

RSpec.describe "admin/donate_statistics/index", type: :view do
  before(:each) do
    assign(:admin_donate_statistics, [
      Admin::DonateStatistic.create!(),
      Admin::DonateStatistic.create!()
    ])
  end

  it "renders a list of admin/donate_statistics" do
    render
  end
end
