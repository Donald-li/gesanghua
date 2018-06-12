class Admin::IncomeSourcesController < Admin::BaseController
  before_action :auth_manage_operation
  before_action :set_income_source, only: [:edit, :update, :destroy, :move]

  def index
    @income_sources = IncomeSource.sorted
  end

  def new
    @income_source = IncomeSource.new
  end

  def create
    @income_source = IncomeSource.new(income_source_params)

    respond_to do |format|
      if @income_source.save
        format.html { redirect_to referer_or(admin_income_sources_path), notice: '添加成功' }
      else
        format.html { render :new }
      end
    end
  end

  def edit

  end

  def update
    respond_to do |format|
      if @income_source.update(income_source_params)
        format.html { redirect_to referer_or(admin_income_sources_path), notice: '修改成功' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @income_source.delete
    respond_to do |format|
      format.html { redirect_to referer_or(admin_income_sources_path), notice: '删除成功' }
    end
  end

  def move
    move_target = params[:to]
    return unless ['higher', 'lower', 'to_top', 'to_bottom'].include?(move_target)
    @income_source.send("move_#{move_target}")
    redirect_to request.referer
  end

  def statistic
    params[:time_start] ||= Time.now.beginning_of_month
    @income_sources = IncomeSource.sorted
    @income_statistics = IncomeRecord.all
    @income_statistics = @income_statistics.where("income_time > ?", params[:time_start]) if params[:time_start].present?
    @income_statistics = @income_statistics.where("income_time < ?", params[:time_end].end_of_day) if params[:time_end].present?
    @income_statistics = @income_statistics.where("income_time > ?", Time.now.beginning_of_day) if params[:fix_time] == 'day'
    @income_statistics = @income_statistics.where("income_time > ?", Time.now.beginning_of_day - 7.day) if params[:fix_time] == 'week'
    @income_statistics = @income_statistics.where("income_time > ?", Time.now.beginning_of_day - 1.month) if params[:fix_time] == 'month'
    @income_statistics = @income_statistics.where("income_time > ?", Time.now.beginning_of_day - 1.year) if params[:fix_time] == 'year'
    @income_statistics = @income_statistics.select("income_source_id, sum(amount) as amount").group(:income_source_id)

    @expend_statistics = ExpenditureRecord.all
    @expend_statistics = @expend_statistics.where("expended_at > ?", params[:time_start]) if params[:time_start].present?
    @expend_statistics = @expend_statistics.where("expended_at < ?", params[:time_end].end_of_day) if params[:time_end].present?
    @expend_statistics = @expend_statistics.where("expended_at > ?", Time.now.beginning_of_day) if params[:fix_time] == 'day'
    @expend_statistics = @expend_statistics.where("expended_at > ?", Time.now.beginning_of_day - 7.day) if params[:fix_time] == 'week'
    @expend_statistics = @expend_statistics.where("expended_at > ?", Time.now.beginning_of_day - 1.month) if params[:fix_time] == 'month'
    @expend_statistics = @expend_statistics.where("expended_at > ?", Time.now.beginning_of_day - 1.year) if params[:fix_time] == 'year'
    @expend_statistics = @expend_statistics.select("income_source_id, sum(amount) as amount").group(:income_source_id)
  end

  private

  def set_income_source
    @income_source = IncomeSource.find(params[:id])
  end

  def income_source_params
    params.require(:income_source).permit!
  end
end
