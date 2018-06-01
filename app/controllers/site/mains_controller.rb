class Site::MainsController < Site::BaseController

  def show
    @adverts = Advert.pc_banner.show.sorted
    @donate_records = DonateRecord.sorted.includes(:donor).limit(20)
    @articles = Article.show.recommend.sorted.limit(6)
    @donate_adverts = Advert.pc_donate_banner.show.sorted.limit(3)
    @partners = Partner.show.sorted
  end

end
