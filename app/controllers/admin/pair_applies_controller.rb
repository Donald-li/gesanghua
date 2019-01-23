class Admin::PairAppliesController < Admin::BaseController
  before_action :set_project_apply, only: [:show, :edit, :update, :destroy, :change_state]

  def index
    @search = ProjectSeasonApply.where(project: Project.pair_project).sorted.ransack(params[:q])
    scope = @search.result
    scope = scope.includes(:school, :season)
    respond_to do |format|
      format.html { @project_applies = scope.page(params[:page]) }
      format.xlsx {
        @project_applies = scope.sorted
        OperateLog.create_export_excel(current_user,  '结对配额列表')
        response.headers['Content-Disposition'] = 'attachment; filename=' + '结对配额列表' + Date.today.to_s + '.xlsx'
      }
    end
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
      if ProjectSeasonApply.find_by(school_id: project_apply_params[:school_id], project_id: @project_apply.project_id, project_season_id: @project_apply.project_season_id).present?
        flash[:notice] = '此学校在本批次还有未完成的申请'
        format.html { render :new }
      elsif @project_apply.save
        format.html { redirect_to referer_or(admin_pair_applies_path), notice: '创建成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @project_apply.update(project_apply_params)
        format.html { redirect_to referer_or(admin_pair_applies_path), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @project_apply.destroy
        format.html { redirect_to referer_or(admin_pair_applies_path), notice: '删除成功。' }
      else
        format.html { redirect_to referer_or(admin_pair_applies_path), notice: '请先删除该配额下的学生。' }
      end
    end
  end

  def change_state
    respond_to do |format|
      if @project_apply.update(pair_state: params[:pair_state])
        format.html {redirect_to referer_or(admin_pair_applies_path), notice: '标记成功。'}
      else
        format.html { redirect_to referer_or(admin_pair_applies_path), notice: '标记失败。' }
      end
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

end
