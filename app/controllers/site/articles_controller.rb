class Site::ArticlesController < Site::BaseController

  def index
    scope = Article.visible.show.sorted
    @articles = scope.page(params[:page]).per(6)
  end

  def show
    @article = Article.find(params[:id])
    @recommend_articles = Article.visible.show.where.not(id: @article.id).limit(3)
  end
end
