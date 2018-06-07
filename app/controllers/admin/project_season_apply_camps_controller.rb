class Admin::ProjectSeasonApplyCampsController < Admin::BaseController
  before_action :check_auth
  before_action :set_apply_camp, only: [:edit, :update, :destroy, :camp_member, :switch]
  before_action :set_apply

  def index
    @search = @apply.apply_camps.sorted.ransack(params[:q])
    scope = @search.result
    @apply_camps = scope.page(params[:page])
  end

  def new
    @apply_camp = ProjectSeasonApplyCamp.new
  end

  def create
    @apply_camp = ProjectSeasonApplyCamp.new(apply_camp_params.merge(camp: @apply.camp, apply: @apply))
    respond_to do |format|
      if @apply_camp.save
        format.html { redirect_to referer_or(admin_camp_project_project_season_apply_camps_path), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @apply_camp.update(apply_camp_params)
        format.html { redirect_to referer_or(admin_camp_project_project_season_apply_camps_path), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @apply_camp.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_camp_project_project_season_apply_camps_path), notice: '删除成功。' }
    end
  end

  def switch
    @apply_camp.execute_state = params[:execute_state]
    respond_to do |format|
      if @apply_camp.save
        format.html { redirect_to referer_or(admin_camp_project_project_season_apply_camps_path), notice: '标记成功。' }
      else
        format.html { redirect_to referer_or(admin_camp_project_project_season_apply_camps_path), notice: '标记失败。' }
      end
    end
  end

  def camp_member
    @students = @apply_camp.camp_members.student.pass.sorted
    @teachers = @apply_camp.camp_members.teacher.pass.sorted
  end

  private
  def set_apply_camp
    @apply_camp = ProjectSeasonApplyCamp.find(params[:id])
  end

  def set_apply
    @apply = ProjectSeasonApply.find(params[:camp_project_id])
  end

  def apply_camp_params
    params.require(:project_season_apply_camp).permit!
  end

  def check_auth
    auth_operate_project(Project.camp_project)
  end
end
