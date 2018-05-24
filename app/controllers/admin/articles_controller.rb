# 资讯管理
class Admin::ArticlesController < Admin::BaseController
  before_action :auth_manage_operation
  before_action :set_article, only: [:show, :edit, :update, :destroy, :switch, :recommend]

  def index
    set_search_end_of_day(:published_at_lteq)
    @search = Article.admin_visible.sorted.ransack(params[:q])
    scope = @search.result
    @articles = scope.page(params[:page])
  end

  def show
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    @article = Article.new(article_params)
    respond_to do |format|
      if @article.save
        @article.attach_image(params[:image_id])
        @article.attach_carousel_images(params[:carousel_image_ids])
        format.html { redirect_to referer_or(admin_articles_url), article: '资讯已增加。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @article.update(article_params)
        @article.attach_image(params[:image_id])
        @article.attach_carousel_images(params[:carousel_image_ids])
        format.html { redirect_to referer_or(admin_articles_url), article: '资讯资料已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_articles_url), article: '资讯已删除。' }
    end
  end

  def switch
    @article.show? ? @article.hidden! : @article.show!
    redirect_to admin_articles_url, notice:  @article.show? ? '资讯已展示' : '资讯已隐藏'
  end

  def recommend
    @article.recommend? ? @article.normal! : @article.recommend!
    redirect_to admin_articles_url, notice:  @article.recommend? ? '已推荐资讯' : '已取消推荐资讯'
  end

  private
    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit!
    end
end
