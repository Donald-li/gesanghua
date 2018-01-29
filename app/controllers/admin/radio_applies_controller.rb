class Admin::RadioAppliesController < Admin::BaseController
  before_action :set_project_apply, only: [:show, :edit, :update, :destroy]

  def index
    @search = ProjectSeasonApply.where(project_id: 5).sorted.ransack(params[:q])
    scope = @search.result.joins(:school)
    @project_applies = scope.page(params[:page])
  end

  def show
  end

  def new
    @project_apply = ProjectSeasonApply.new
  end

  def edit
  end

  def create
    @project_apply = ProjectSeasonApply.new(radio_apply_params)

    respond_to do |format|
      if @project_apply.save
        format.html { redirect_to admin_radio_applies_path, notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @project_apply.update(radio_apply_params)
        format.html { redirect_to admin_radio_applies_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @project_apply.destroy
    respond_to do |format|
      format.html { redirect_to admin_radio_applies_path, notice: '删除成功。' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_apply
      @project_apply = ProjectSeasonApply.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def radio_apply_params
      params.require(:radio_apply).permit!
    end
end
