# 公告管理
class Admin::AnnouncementsController < Admin::BaseController
  before_action :auth_manage_operation
  before_action :set_announcement, only: [:show, :edit, :update, :destroy, :switch]

  def index
    set_search_end_of_day(:published_at_lteq)
    @search = Article.announcement.sorted.ransack(params[:q])
    scope = @search.result
    @announcements = scope.page(params[:page])
  end

  def show
  end

  def new
    @announcement = Article.announcement.new
  end

  def edit
  end

  def create
    @announcement = Article.announcement.new(announcement_params)
    respond_to do |format|
      if @announcement.save
        @announcement.attach_image(params[:image_id])
        @announcement.attach_carousel_images(params[:carousel_image_ids])
        format.html { redirect_to referer_or(admin_announcements_url), notice: '公告已增加。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @announcement.update(announcement_params)
        @announcement.attach_image(params[:image_id])
        @announcement.attach_carousel_images(params[:carousel_image_ids])
        format.html { redirect_to referer_or(admin_announcements_url), notice: '公告已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @announcement.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_announcements_url), notice: '公告已删除。' }
    end
  end

  def switch
    @announcement.show? ? @announcement.hidden! : @announcement.show!
    redirect_to referer_or(admin_announcements_url), notice:  @announcement.show? ? '公告已展示' : '公告已隐藏'
  end

  private
    def set_announcement
      @announcement = Article.find(params[:id])
    end

    def announcement_params
      params.require(:article).permit!
    end
end
