require 'rails_helper'

RSpec.describe "admin/article_categories/edit", type: :view do
  before(:each) do
    @admin_article_category = assign(:admin_article_category, Admin::ArticleCategory.create!())
  end

  it "renders the edit admin_article_category form" do
    render

    assert_select "form[action=?][method=?]", admin_article_category_path(@admin_article_category), "post" do
    end
  end
end
