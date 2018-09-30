class Admin::WorkplacesController < Admin::BaseController
  before_action :set_workplace, only: [:show, :edit, :update, :destroy, :switch]

  def index
    @search = Workplace.sorted.ransack(params[:q])
    scope = @search.result
    @workplaces = scope.page(params[:page])
  end

  def show
  end

  def new
    @workplace = Workplace.new
  end

  def edit
  end

  def create
    @workplace = Workplace.new(workplace_params)

    respond_to do |format|
      if @workplace.save
        format.html { redirect_to referer_or(admin_workplaces_path), notice: '添加成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @workplace.update(workplace_params)
        @workplace.save
        format.html { redirect_to referer_or(admin_workplaces_path), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @workplace.destroy
        format.html { redirect_to referer_or(admin_workplaces_path), notice: '删除成功。' }
      else
        format.html { redirect_to referer_or(admin_workplaces_path), notice: '请先删除该工作地点下的任务。' }
      end
    end
  end

  def switch
    @workplace.show? ? @workplace.hidden! : @workplace.show!
    redirect_to referer_or(admin_workplaces_path), notice:  @workplace.show? ? '已显示' : '已隐藏'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workplace
      @workplace = Workplace.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def workplace_params
      params.require(:workplace).permit!
    end
end
