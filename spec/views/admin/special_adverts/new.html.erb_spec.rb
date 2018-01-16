require 'rails_helper'

RSpec.describe "admin/special_adverts/new", type: :view do
  before(:each) do
    assign(:admin_special_advert, Admin::SpecialAdvert.new())
  end

  it "renders new admin_special_advert form" do
    render

    assert_select "form[action=?][method=?]", admin_special_adverts_path, "post" do
    end
  end
end
