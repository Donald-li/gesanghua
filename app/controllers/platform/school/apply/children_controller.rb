class Platform::School::Apply::ChildrenController < Platform::School::BaseController

  def index
    @apply = ProjectSeasonApply.find(params[:id])
    scope = @apply.children.pass.sorted
    @children = scope.page(params[:page]).per(10)
  end

  def show
    @apply = ProjectSeasonApply.find(params[:id])
    scope = @apply.children.draft.sorted
    scope = scope.where("name like :q", q: "%#{params[:name]}%") if params[:name].present?
    @children = scope
  end

  def new
    @apply = ProjectSeasonApply.find(params[:id])
  end
end
