class Site::ArticlesController < Site::BaseController

  def index
    scope = Article.visible.show.sorted
    @articles = scope.page(params[:page]).per(6)
  end

  def show
    @article = Article.find(params[:id])
  end
end
