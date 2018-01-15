require 'rails_helper'

RSpec.describe "admin/data_statistics/show", type: :view do
  before(:each) do
    @admin_data_statistic = assign(:admin_data_statistic, Admin::DataStatistic.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
