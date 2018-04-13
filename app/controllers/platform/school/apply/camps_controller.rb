class Platform::School::Apply::CampsController < Platform::School::BaseController
  before_action :set_apply_camp
  before_action :set_apply_camp, only: [:show]

  def index
    @school = current_user.teacher.school
    scope = ProjectSeasonApplyCamp.where(school: @school).sorted
    @apply_camps = scope.page(params[:page]).per(8)
  end

  def show
  end

  private
  def check_manage_limit
    redirect_to root_path unless current_teacher.manage_projects.where(alias: 'camp').exists?
  end

  def set_apply_camp
    @apply_camp = ProjectSeasonApplyCamp.find(params[:id])
  end

end
