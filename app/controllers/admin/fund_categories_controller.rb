class Admin::FundCategoriesController < Admin::BaseController

  before_action :set_fund_category, only: [:show, :edit, :update, :destroy, :move, :switch]

  def index
    @search = FundCategory.sorted.ransack(params[:q])
    scope = @search.result.includes(:funds)
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
        format.html { redirect_to referer_or(admin_fund_categories_path), notice: '添加成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @fund_category.update(fund_category_params)
        format.html { redirect_to referer_or(admin_fund_categories_path), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @fund_category.destroy
        format.html { redirect_to referer_or(admin_fund_categories_path), notice: '删除成功。' }
      else
        format.html { redirect_to referer_or(admin_fund_categories_path), notice: '请先删除二级分类。' }
      end
    end
  end

  def switch
    @fund_category.show? ? @fund_category.hidden! : @fund_category.show!
    redirect_to referer_or(admin_fund_categories_path), notice:  @fund_category.show? ? '已显示' : '已隐藏'
  end

  def move
    move_target = params[:to]
    return unless ['higher', 'lower', 'to_top', 'to_bottom'].include?(move_target)
    @fund_category.send("move_#{move_target}")
    redirect_to request.referer
  end

  def statistic
    params[:time_start] ||= Time.now.beginning_of_month
    @fund_categories = FundCategory.sorted
    @income_statistics = IncomeRecord.all
    if params[:fix_time].present?
      params[:time_start] = Time.now.beginning_of_day if params[:fix_time] == 'day'
      params[:time_start] = Time.now.beginning_of_week if params[:fix_time] == 'week'
      params[:time_start] = Time.now.beginning_of_month if params[:fix_time] == 'month'
      params[:time_start] = Time.now.beginning_of_year if params[:fix_time] == 'year'
    end
    @income_statistics = @income_statistics.where("income_time >= ?", params[:time_start]) if params[:time_start].present?
    @income_statistics = @income_statistics.where("income_time <= ?", params[:time_end].end_of_day) if params[:time_end].present?
    @income_statistics = @income_statistics.select("fund_id, sum(amount) as amount").group(:fund_id)

    @expend_statistics = ExpenditureRecord.all
    @expend_statistics = @expend_statistics.where("expended_at >= ?", params[:time_start]) if params[:time_start].present?
    @expend_statistics = @expend_statistics.where("expended_at <= ?", params[:time_end].end_of_day) if params[:time_end].present?
    @expend_statistics = @expend_statistics.select("fund_id, sum(amount) as amount").group(:fund_id)
  end

  private
    def set_fund_category
      @fund_category = FundCategory.find(params[:id])
    end

    def fund_category_params
      params.require(:fund_category).permit!
    end
end
