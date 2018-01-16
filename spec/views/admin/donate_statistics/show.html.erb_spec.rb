require 'rails_helper'

RSpec.describe "admin/donate_statistics/show", type: :view do
  before(:each) do
    @admin_donate_statistic = assign(:admin_donate_statistic, Admin::DonateStatistic.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
