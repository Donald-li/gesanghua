require 'rails_helper'

RSpec.describe "admin/pairs/show", type: :view do
  before(:each) do
    @admin_pair = assign(:admin_pair, Admin::Pair.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
