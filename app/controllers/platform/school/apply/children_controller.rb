class Platform::School::Apply::ChildrenController < Platform::School::BaseController

  def index
    @apply = ProjectSeasonApply.find(params[:id])
    scope = @apply.children.pass.sorted
    @children = scope.page(params[:page]).per(10)
  end

  def show
  end
end
