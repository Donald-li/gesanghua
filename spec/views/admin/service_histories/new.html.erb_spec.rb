require 'rails_helper'

RSpec.describe "admin/service_histories/new", type: :view do
  before(:each) do
    assign(:admin_service_history, Admin::ServiceHistory.new())
  end

  it "renders new admin_service_history form" do
    render

    assert_select "form[action=?][method=?]", admin_service_histories_path, "post" do
    end
  end
end
