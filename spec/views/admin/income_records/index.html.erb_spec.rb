require 'rails_helper'

RSpec.describe "admin/income_records/index", type: :view do
  before(:each) do
    assign(:admin_income_records, [
      Admin::IncomeRecord.create!(),
      Admin::IncomeRecord.create!()
    ])
  end

  it "renders a list of admin/income_records" do
    render
  end
end
