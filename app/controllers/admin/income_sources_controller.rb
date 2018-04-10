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
        format.html { redirect_to admin_income_sources_path, notice: '添加成功' }
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
        format.html { redirect_to admin_income_sources_path, notice: '修改成功' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @income_source.delete
    respond_to do |format|
      format.html { redirect_to admin_income_sources_path, notice: '删除成功' }
    end
  end

  def move
    move_target = params[:to]
    return unless ['higher', 'lower', 'to_top', 'to_bottom'].include?(move_target)
    @income_source.send("move_#{move_target}")
    redirect_to request.referer
  end

  private

  def set_income_source
    @income_source = IncomeSource.find(params[:id])
  end

  def income_source_params
    params.require(:income_source).permit!
  end
end
