require 'rails_helper'

RSpec.describe "admin/special_adverts/edit", type: :view do
  before(:each) do
    @admin_special_advert = assign(:admin_special_advert, Admin::SpecialAdvert.create!())
  end

  it "renders the edit admin_special_advert form" do
    render

    assert_select "form[action=?][method=?]", admin_special_advert_path(@admin_special_advert), "post" do
    end
  end
end
