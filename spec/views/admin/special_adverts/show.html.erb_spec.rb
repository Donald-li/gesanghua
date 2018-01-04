require 'rails_helper'

RSpec.describe "admin/special_adverts/show", type: :view do
  before(:each) do
    @admin_special_advert = assign(:admin_special_advert, Admin::SpecialAdvert.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
