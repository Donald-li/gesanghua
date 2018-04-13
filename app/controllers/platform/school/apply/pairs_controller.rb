class Platform::School::Apply::PairsController < Platform::School::BaseController
  before_action :set_apply, only: [:show]

  def index
    @school = current_user.teacher.school
    scope = ProjectSeasonApply.where(project: Project.pair_project, school: @school).sorted
    @applies = scope.page(params[:page]).per(8)
  end

  def show
  end

  private
  def set_apply
    @apply = ProjectSeasonApply.find(params[:id])
  end

end
