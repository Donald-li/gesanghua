class Site::ArticlesController < Site::BaseController

  def index
    params[:category_id] ||= ArticleCategory.sorted.first.id
    scope = Article.visible.show.sorted
    scope = scope.where(article_category_id: params[:category_id])
    @articles = scope.page(params[:page]).per(8)
    @recommend_articles = Article.visible.show.recommend.sorted
  end

  def show
    @article = Article.find(params[:id])
    @recommend_articles = Article.visible.show.recommend.where.not(id: @article.id).limit(3)
  end
end
