class Platform::School::Apply::CampsController < Platform::School::BaseController
  before_action :set_apply_camp, only: [:show]

  def index
    @school = current_user.school
    scope = ProjectSeasonApplyCamp.where(school: @school).sorted
    @apply_camps = scope.page(params[:page]).per(8)
  end

  def show
  end

  private
  def set_apply_camp
    @apply_camp = ProjectSeasonApplyCamp.find(params[:id])
  end

end
