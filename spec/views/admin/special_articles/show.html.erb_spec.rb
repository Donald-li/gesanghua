require 'rails_helper'

RSpec.describe "admin/special_articles/show", type: :view do
  before(:each) do
    @admin_special_article = assign(:admin_special_article, Admin::SpecialArticle.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
