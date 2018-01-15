require 'rails_helper'

RSpec.describe "admin/data_statistics/index", type: :view do
  before(:each) do
    assign(:admin_data_statistics, [
      Admin::DataStatistic.create!(),
      Admin::DataStatistic.create!()
    ])
  end

  it "renders a list of admin/data_statistics" do
    render
  end
end
