class Admin::SpecialArticlesController < Admin::BaseController
  before_action :set_special_article, only: [:edit, :update, :destroy]
  before_action :set_special

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    @article = Article.new(special_article_params.merge(kind: 2))
    respond_to do |format|
      if @article.save
        @article.attach_image(params[:image_id])
        @special.special_articles.create(article_id: @article.id)
        format.html { redirect_to edit_admin_special_path(@special, anchor: "special-articles"), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @article.update(special_article_params)
        @article.attach_image(params[:image_id])
        format.html { redirect_to edit_admin_special_path(@special, anchor: "special-articles"), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to edit_admin_special_path(@special, anchor: "special-articles"), notice: '删除成功。' }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_special_article
    @article = Article.find(params[:id])
  end

  def set_special
    @special = Special.find(params[:special_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def special_article_params
    params.require(:article).permit!
  end
end
