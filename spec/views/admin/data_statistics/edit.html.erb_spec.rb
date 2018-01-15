require 'rails_helper'

RSpec.describe "admin/data_statistics/edit", type: :view do
  before(:each) do
    @admin_data_statistic = assign(:admin_data_statistic, Admin::DataStatistic.create!())
  end

  it "renders the edit admin_data_statistic form" do
    render

    assert_select "form[action=?][method=?]", admin_data_statistic_path(@admin_data_statistic), "post" do
    end
  end
end
