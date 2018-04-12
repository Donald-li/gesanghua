class Site::MainsController < Site::BaseController

  def show
    @adverts = Advert.visible.sorted
    @donate_records = DonateRecord.sorted
    @articles = Article.show.recommend.sorted.limit(6)
    @partners = Partner.show.sorted
  end

end
