class Admin::PairAppliesController < Admin::BaseController
  before_action :check_auth
  before_action :set_project_apply, only: [:show, :edit, :update, :destroy]

  def index
    @search = ProjectSeasonApply.where(project_id: 1).sorted.ransack(params[:q])
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
    @school = School.find(project_apply_params[:school_id])
    @project_apply = ProjectSeasonApply.new(project_apply_params.merge(province: @school.province, city: @school.city, district: @school.district))

    respond_to do |format|
      if ProjectSeasonApply.find_by(school_id: project_apply_params[:school_id], id: project_apply_params[:id]).present?
        flash[:notice] = '此学校在本批次还有未完成的申请'
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
    @project_apply = ProjectSeasonApply.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_apply_params
    params.require(:project_season_apply).permit!
  end

  def check_auth
    auth_operate_project(Project.pair_project)
  end
end
