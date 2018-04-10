class Site::MainsController < Site::BaseController

  def show
    @adverts = Advert.visible.sorted
    @donate_records = DonateRecord.sorted
    @articles = Article.show.recommend.sorted.limit(6)
    @total_donate_amount = Project.sum(:donate_record_amount_count)
    @partners = Partner.show.sorted
  end

end
