class Admin::FinanceCategoriesController < Admin::BaseController
  before_action :set_finance_category, only: [:show, :edit, :update, :destroy, :move, :switch]

  def index
    @search = FinanceCategory.sorted.ransack(params[:q])
    scope = @search.result
    @finance_categories = scope.page(params[:page])
  end

  def show
  end

  def new
    @finance_category = FinanceCategory.new
  end

  def edit
  end

  def create
    @finance_category = FinanceCategory.new(finance_category_params)

    respond_to do |format|
      if @finance_category.save
        format.html { redirect_to admin_finance_categories_path, notice: '添加成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @finance_category.update(finance_category_params)
        format.html { redirect_to admin_finance_categories_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @finance_category.destroy
    respond_to do |format|
      format.html { redirect_to admin_finance_categories_path, notice: '删除成功。' }
    end
  end

  def switch
    @finance_category.show? ? @finance_category.hidden! : @finance_category.show!
    redirect_to admin_finance_categories_path, notice:  @finance_category.show? ? '已显示' : '已隐藏'
  end

  def move
    move_target = params[:to]
    return unless ['higher', 'lower', 'to_top', 'to_bottom'].include?(move_target)
    @finance_category.send("move_#{move_target}")
    redirect_to request.referer
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_finance_category
      @finance_category = FinanceCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def finance_category_params
      params.require(:finance_category).permit!
    end
end
