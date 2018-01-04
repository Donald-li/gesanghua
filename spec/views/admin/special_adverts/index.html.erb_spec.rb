require 'rails_helper'

RSpec.describe "admin/special_adverts/index", type: :view do
  before(:each) do
    assign(:admin_special_adverts, [
      Admin::SpecialAdvert.create!(),
      Admin::SpecialAdvert.create!()
    ])
  end

  it "renders a list of admin/special_adverts" do
    render
  end
end
