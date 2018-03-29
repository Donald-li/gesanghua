class Site::MainsController < Site::BaseController

  def show
    @adverts = Advert.show

    @donate_records = DonateRecord.paid.sorted

    @articles = Article.show.recommend.sorted.limit(6)
  end

end
