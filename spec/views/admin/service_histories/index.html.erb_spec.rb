require 'rails_helper'

RSpec.describe "admin/service_histories/index", type: :view do
  before(:each) do
    assign(:admin_service_histories, [
      Admin::ServiceHistory.create!(),
      Admin::ServiceHistory.create!()
    ])
  end

  it "renders a list of admin/service_histories" do
    render
  end
end
