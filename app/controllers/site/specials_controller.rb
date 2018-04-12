class Site::SpecialsController < Site::BaseController

  def index
    scope = Special.show.sorted
    @specials = scope.page(params[:page]).per(8)
    @recommend_articles = Article.visible.show.recommend.sorted
  end

  def show
    @special = Special.find(params[:id])
    @text_news = @special.articles.text_news.reverse_sorted
    if @special.single?
      scope = @special.articles.image_news.reverse_sorted
      @image_news = scope.page(params[:page]).per(6)
      render 'template1'
    elsif @special.double?
      @image_news = @special.articles.image_news.reverse_sorted
      render 'template2'
    end
  end

end
