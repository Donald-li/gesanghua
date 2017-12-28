require 'rails_helper'

RSpec.describe "admin/article_categories/show", type: :view do
  before(:each) do
    @admin_article_category = assign(:admin_article_category, Admin::ArticleCategory.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
