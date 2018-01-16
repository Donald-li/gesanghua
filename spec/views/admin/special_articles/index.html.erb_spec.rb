require 'rails_helper'

RSpec.describe "admin/special_articles/index", type: :view do
  before(:each) do
    assign(:admin_special_articles, [
      Admin::SpecialArticle.create!(),
      Admin::SpecialArticle.create!()
    ])
  end

  it "renders a list of admin/special_articles" do
    render
  end
end
