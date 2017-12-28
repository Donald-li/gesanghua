require 'rails_helper'

RSpec.describe "admin/article_categories/new", type: :view do
  before(:each) do
    assign(:admin_article_category, Admin::ArticleCategory.new())
  end

  it "renders new admin_article_category form" do
    render

    assert_select "form[action=?][method=?]", admin_article_categories_path, "post" do
    end
  end
end
