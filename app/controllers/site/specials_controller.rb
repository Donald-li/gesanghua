class Site::SpecialsController < Site::BaseController

  def index
    scope = Special.show.sorted
    @specials = scope.page(params[:page]).per(3)
  end

  def show
    @special = Special.find(params[:id])
    @special_advert = @special.adverts.first
    @special_articles = @special.articles
    @special_article1 = @special.articles.first
    @special_article2 = @special.articles.second
    @special_article3 = @special.articles.third
    scope = Article.visible.show.sorted
    @articles = scope.page(params[:page]).per(6)
    if @special.single?
      render 'template1'
    elsif @special.double?
      render 'template2'
    end
  end

end
