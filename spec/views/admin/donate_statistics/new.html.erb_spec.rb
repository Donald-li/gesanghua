require 'rails_helper'

RSpec.describe "admin/donate_statistics/new", type: :view do
  before(:each) do
    assign(:admin_donate_statistic, Admin::DonateStatistic.new())
  end

  it "renders new admin_donate_statistic form" do
    render

    assert_select "form[action=?][method=?]", admin_donate_statistics_path, "post" do
    end
  end
end
