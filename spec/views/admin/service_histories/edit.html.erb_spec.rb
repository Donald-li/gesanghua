require 'rails_helper'

RSpec.describe "admin/service_histories/edit", type: :view do
  before(:each) do
    @admin_service_history = assign(:admin_service_history, Admin::ServiceHistory.create!())
  end

  it "renders the edit admin_service_history form" do
    render

    assert_select "form[action=?][method=?]", admin_service_history_path(@admin_service_history), "post" do
    end
  end
end
