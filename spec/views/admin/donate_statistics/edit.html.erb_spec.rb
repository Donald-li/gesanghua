require 'rails_helper'

RSpec.describe "admin/donate_statistics/edit", type: :view do
  before(:each) do
    @admin_donate_statistic = assign(:admin_donate_statistic, Admin::DonateStatistic.create!())
  end

  it "renders the edit admin_donate_statistic form" do
    render

    assert_select "form[action=?][method=?]", admin_donate_statistic_path(@admin_donate_statistic), "post" do
    end
  end
end
