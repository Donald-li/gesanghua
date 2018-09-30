class Admin::HomeVisitsController < Admin::BaseController

  def index
    @child = ProjectSeasonApplyChild.find(params[:id])
    scope = @child.visits.sorted
    @visits = scope.page(params[:page])
  end

  def show
    @visit = Visit.find(params[:id])
  end

end
