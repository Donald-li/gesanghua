class Admin::CampProjectsController < Admin::BaseController
  before_action :set_project, only: [:show, :edit, :accrue, :update, :destroy, :switch, :change_state, :camp_member]

  def index
    @search = ProjectSeasonApply.where(project_id: Project.camp_project.id).pass.raise_project.sorted.ransack(params[:q])
    scope = @search.result
    @projects = scope.page(params[:page])
  end

  def show
  end

  def new
    @project = ProjectSeasonApply.new
  end

  def edit
  end

  # 计提管理费
  def accrue
    @item = @project
    @project = Project.camp_project
    @management_fee = ManagementFee.new
    render template: '/admin/management_fees/accrue'
  end

  def create
    @project = ProjectSeasonApply.new(project_params.merge(audit_state: 'pass', project_type: 'raise_project'))
    respond_to do |format|
      if @project.save
        @project.attach_cover_image(params[:cover_image_id])
        format.html {redirect_to referer_or(admin_camp_projects_path), notice: '新增成功。'}
      else
        format.html {render :new}
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params.merge(project_type: 'raise_project'))
        @project.attach_cover_image(params[:cover_image_id])
        format.html {redirect_to referer_or(admin_camp_projects_path), notice: '设置成功。'}
      else
        format.html {render :edit}
      end
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html {redirect_to referer_or(admin_camp_projects_path), notice: '删除成功。'}
    end
  end

  def switch
    @project.show? ? @project.hidden! : @project.show!
    redirect_to referer_or(admin_camp_projects_url), notice: @project.show? ? '项目已显示' : '项目已隐藏'
  end

  def change_state
    respond_to do |format|
      if @project.update(camp_state: params[:camp_state])
        format.html {redirect_to referer_or(admin_camp_projects_path), notice: '标记成功。'}
      else
        format.html {render :edit}
      end
    end
  end

  def camp_member
    # TODO: 需要整理显示的逻辑
    @students = ProjectSeasonApplyCampMember.student.pass.where(apply: @project).sorted
    @teachers = ProjectSeasonApplyCampMember.teacher.pass.where(apply: @project).sorted
    # .joins(:apply_camp).where("project_season_apply_camps.execute_state = ?", 3)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = ProjectSeasonApply.find(params[:id])
    auth_operate_project(@project)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project_season_apply).permit!
  end

end
