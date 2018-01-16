require 'rails_helper'

RSpec.describe "admin/income_records/show", type: :view do
  before(:each) do
    @admin_income_record = assign(:admin_income_record, Admin::IncomeRecord.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
