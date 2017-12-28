require 'rails_helper'

RSpec.describe "Admin::ArticleCategories", type: :request do
  describe "GET /admin_article_categories" do
    it "works! (now write some real specs)" do
      get admin_article_categories_path
      expect(response).to have_http_status(200)
    end
  end
end
