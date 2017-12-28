require 'rails_helper'

RSpec.describe "admin/article_categories/index", type: :view do
  before(:each) do
    assign(:admin_article_categories, [
      Admin::ArticleCategory.create!(),
      Admin::ArticleCategory.create!()
    ])
  end

  it "renders a list of admin/article_categories" do
    render
  end
end
