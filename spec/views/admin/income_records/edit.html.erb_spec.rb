require 'rails_helper'

RSpec.describe "admin/income_records/edit", type: :view do
  before(:each) do
    @admin_income_record = assign(:admin_income_record, Admin::IncomeRecord.create!())
  end

  it "renders the edit admin_income_record form" do
    render

    assert_select "form[action=?][method=?]", admin_income_record_path(@admin_income_record), "post" do
    end
  end
end
