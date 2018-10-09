class Admin::SupportCategoriesController < Admin::BaseController

  before_action :set_support_category, only: [:show, :edit, :update, :destroy, :move, :switch]

  def index
    @search = SupportCategory.sorted.ransack(params[:q])
    scope = @search.result
    @support_categories = scope.page(params[:page])
  end

  def show
  end

  def new
    @support_category = SupportCategory.new
  end

  def edit
  end

  def create
    @support_category = SupportCategory.new(support_category_params)

    respond_to do |format|
      if @support_category.save
        format.html { redirect_to referer_or(admin_support_categories_path), notice: '添加成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @support_category.update(support_category_params)
        format.html { redirect_to referer_or(admin_support_categories_path), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @support_category.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_support_categories_path), notice: '删除成功。' }
    end
  end

  def switch
    @support_category.show? ? @support_category.hidden! : @support_category.show!
    redirect_to referer_or(admin_support_categories_path), notice:  @support_category.show? ? '已显示' : '已隐藏'
  end

  def move
    move_target = params[:to]
    return unless ['higher', 'lower', 'to_top', 'to_bottom'].include?(move_target)
    @support_category.send("move_#{move_target}")
    redirect_to request.referer
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_support_category
      @support_category = SupportCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def support_category_params
      params.require(:support_category).permit!
    end
end
