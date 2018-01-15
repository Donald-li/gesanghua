require 'rails_helper'

RSpec.describe "admin/income_records/new", type: :view do
  before(:each) do
    assign(:admin_income_record, Admin::IncomeRecord.new())
  end

  it "renders new admin_income_record form" do
    render

    assert_select "form[action=?][method=?]", admin_income_records_path, "post" do
    end
  end
end
