# 资讯分类管理
class Admin::ArticleCategoriesController < Admin::BaseController
  before_action :auth_manage_operation
  before_action :set_article_category, only: [:show, :edit, :update, :destroy, :move, :switch]

  def index
    @search = ArticleCategory.sorted.ransack(params[:q])
    scope = @search.result
    @article_categories = scope.page(params[:page])
  end

  def show
  end

  def new
    @article_category = ArticleCategory.new
  end

  def edit
  end

  def create
    @article_category = ArticleCategory.new(article_category_params)

    respond_to do |format|
      if @article_category.save
        format.html { redirect_to admin_article_categories_path, notice: '添加成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @article_category.update(article_category_params)
        format.html { redirect_to admin_article_categories_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @article_category.destroy
    respond_to do |format|
      format.html { redirect_to admin_article_categories_path, notice: '删除成功。' }
    end
  end

  def switch
    @article_category.show? ? @article_category.hidden! : @article_category.show!
    redirect_to admin_article_categories_path, notice:  @article_category.show? ? '已显示' : '已隐藏'
  end

  def move
    move_target = params[:to]
    return unless ['higher', 'lower', 'to_top', 'to_bottom'].include?(move_target)
    @article_category.send("move_#{move_target}")
    redirect_to request.referer
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article_category
      @article_category = ArticleCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_category_params
      params.require(:article_category).permit!
    end
end
