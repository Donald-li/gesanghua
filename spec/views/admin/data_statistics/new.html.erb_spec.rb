require 'rails_helper'

RSpec.describe "admin/data_statistics/new", type: :view do
  before(:each) do
    assign(:admin_data_statistic, Admin::DataStatistic.new())
  end

  it "renders new admin_data_statistic form" do
    render

    assert_select "form[action=?][method=?]", admin_data_statistics_path, "post" do
    end
  end
end
