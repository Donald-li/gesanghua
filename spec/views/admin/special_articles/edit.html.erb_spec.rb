require 'rails_helper'

RSpec.describe "admin/special_articles/edit", type: :view do
  before(:each) do
    @admin_special_article = assign(:admin_special_article, Admin::SpecialArticle.create!())
  end

  it "renders the edit admin_special_article form" do
    render

    assert_select "form[action=?][method=?]", admin_special_article_path(@admin_special_article), "post" do
    end
  end
end
