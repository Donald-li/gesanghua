class Site::DonateRecordsController < Site::BaseController

  def index
      scope = DonateRecord
      if params[:project].present?
        @owner = Project.find(params[:project])
        scope = scope.where(project_id: params[:project]) if params[:project].present?
      end
      if params[:apply].present?
        @owner = ProjectSeasonApply.find(params[:apply])
        scope = scope.where(project_season_apply_id: params[:apply])
      end
      @records = scope.sorted.page(params[:page]).per(6)
  end
end
