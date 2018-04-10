class Admin::FundCategoriesController < Admin::BaseController
  before_action :auth_manage_finanical
  before_action :set_fund_category, only: [:show, :edit, :update, :destroy, :move, :switch]

  def index
    @search = FundCategory.sorted.ransack(params[:q])
    scope = @search.result
    @fund_categories = scope.page(params[:page])
  end

  def show
  end

  def new
    @fund_category = FundCategory.new
  end

  def edit
  end

  def create
    @fund_category = FundCategory.new(fund_category_params)

    respond_to do |format|
      if @fund_category.save
        format.html { redirect_to admin_fund_categories_path, notice: '添加成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @fund_category.update(fund_category_params)
        format.html { redirect_to admin_fund_categories_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @fund_category.destroy
    respond_to do |format|
      format.html { redirect_to admin_fund_categories_path, notice: '删除成功。' }
    end
  end

  def switch
    @fund_category.show? ? @fund_category.hidden! : @fund_category.show!
    redirect_to admin_fund_categories_path, notice:  @fund_category.show? ? '已显示' : '已隐藏'
  end

  def move
    move_target = params[:to]
    return unless ['higher', 'lower', 'to_top', 'to_bottom'].include?(move_target)
    @fund_category.send("move_#{move_target}")
    redirect_to request.referer
  end

  private
    def set_fund_category
      @fund_category = FundCategory.find(params[:id])
    end

    def fund_category_params
      params.require(:fund_category).permit!
    end
end
