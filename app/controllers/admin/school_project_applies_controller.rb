class Admin::SchoolProjectAppliesController < Admin::BaseController
  before_action :auth_manage_operation
  before_action :set_school_project_apply, only: [:show]
  before_action :set_school

  def index
    @search = @school.project_season_applies.sorted.ransack(params[:q])
    scope = @search.result
    @school_project_applies = scope.page(params[:page])
  end

  def show
    @project = @school_project_apply.project
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_school_project_apply
      @school_project_apply = ProjectSeasonApply.find(params[:id])
    end

    def set_school
      @school = School.find(params[:school_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def school_project_apply_params
      params.require(:school_project_apply).permit!
    end
end
