require 'rails_helper'

RSpec.describe "admin/service_histories/show", type: :view do
  before(:each) do
    @admin_service_history = assign(:admin_service_history, Admin::ServiceHistory.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
