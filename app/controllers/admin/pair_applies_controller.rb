class Admin::PairAppliesController < Admin::BaseController
  before_action :set_project_apply, only: [:show, :edit, :update, :destroy]

  def index
    @search = ProjectApply.sorted.ransack(params[:q])
    scope = @search.result.joins(:school)
    @project_applies = scope.page(params[:page])
  end

  def show
  end

  def new
    @project_apply = ProjectApply.new
  end

  def edit
  end

  def create
    @project_apply = ProjectApply.new(project_apply_params)

    respond_to do |format|
      if ProjectApply.find_by(school_id: project_apply_params[:school_id], project_id: project_apply_params[:project_id]).present?
        flash[:notice] = '此学校在本年度还有未完成的申请'
        format.html { render :new }
      elsif @project_apply.save
        format.html { redirect_to admin_pair_applies_path, notice: '创建成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @project_apply.update(project_apply_params)
        format.html { redirect_to admin_pair_applies_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @project_apply.destroy
    respond_to do |format|
      format.html { redirect_to admin_pair_applies_path, notice: '删除成功。' }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_project_apply
    @project_apply = ProjectApply.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_apply_params
    params.require(:project_apply).permit!
  end
end
