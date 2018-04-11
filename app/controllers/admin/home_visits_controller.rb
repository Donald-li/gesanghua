class Admin::HomeVisitsController < Admin::BaseController
  before_action :check_auth

  def index
    @child = ProjectSeasonApplyChild.find(params[:id])
    scope = @child.visits.sorted
    @visits = scope.page(params[:page])
  end

  def show
    @visit = Visit.find(params[:id])
  end

  private
  def check_auth
    auth_operate_project(Project.pair_project)
  end
end
