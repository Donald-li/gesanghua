class Platform::School::Apply::PairsController < Platform::School::BaseController

  def index
    @school = current_user.school
    scope = ProjectSeasonApply.where(project: Project.pair_project, school: @school).sorted
    @applies = scope.page(params[:page]).per(8)
  end

  def show
    @apply = ProjectSeasonApply.find(params[:id])
  end
end
