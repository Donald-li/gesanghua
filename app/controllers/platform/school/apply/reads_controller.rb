class Platform::School::Apply::ReadsController < Platform::School::BaseController
  before_action :set_apply, only: [:show]
  before_action :set_school

  def index
    scope = ProjectSeasonApply.where(project: Project.read_project, school: @school).sorted
    @applies = scope.page(params[:page]).per(8)
  end

  def show
  end

  def supplement

  end

  def new
    @apply = ProjectSeasonApply.new
  end

  private
  def set_apply
    @apply = ProjectSeasonApply.find(params[:id])
  end

  def set_school
    @school = current_user.school
  end

end
