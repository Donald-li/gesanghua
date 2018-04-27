class Site::PagesController < Site::BaseController

  def show
    @pages = Page.show.sorted
    @page = Page.find_by(alias: params[:alias])
  end
end
