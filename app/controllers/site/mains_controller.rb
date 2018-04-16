class Site::MainsController < Site::BaseController

  def show
    @adverts = Advert.pc_banner.show.sorted
    @donate_records = DonateRecord.sorted
    @articles = Article.show.recommend.sorted.limit(6)
    @partners = Partner.show.sorted
  end

end
