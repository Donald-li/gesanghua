class Site::AnnouncementsController < Site::BaseController

  def close_announcement
    session[:hide_announcement] = true
  end

  def show
    @announcement = Article.announcement.find(params[:id])
  end

end
