require 'rails_helper'

RSpec.describe "admin/special_articles/new", type: :view do
  before(:each) do
    assign(:admin_special_article, Admin::SpecialArticle.new())
  end

  it "renders new admin_special_article form" do
    render

    assert_select "form[action=?][method=?]", admin_special_articles_path, "post" do
    end
  end
end
