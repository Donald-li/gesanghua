class Site::ArticlesController < Site::BaseController

  def index
    scope = Article.visible.show.sorted
    scope = scope.where(article_category_id: params[:category_id]) if params[:category_id].present?
    @articles = scope.page(params[:page]).per(8)
    @recommend_articles = Article.visible.show.recommend.sorted
  end

  def show
    @article = Article.find(params[:id])
    @recommend_articles = Article.visible.show.recommend.where.not(id: @article.id).limit(3)
  end
end
