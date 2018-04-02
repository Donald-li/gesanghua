class Site::MainsController < Site::BaseController

  def show
    @adverts = Advert.show
    @donate_records = DonateRecord.paid.sorted
    @articles = Article.show.recommend.sorted.limit(6)
    @total_donate_amount = Project.sum(:donate_record_amount_count)
    @partners = Partner.show.sorted
  end

end
