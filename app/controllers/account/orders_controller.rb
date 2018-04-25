class Account::OrdersController < Account::BaseController

  before_action :set_per

  def index
    respond_to do |format|
      format.html do
        scope = current_user.donate_records.visible.where.not(project_id: nil).includes(:project, :owner, :donor).sorted
        scope = scope.where(project_id: params[:project_id]) if params[:project_id].present?
        @donate_records = scope.page(params[:page]).per(8)
        @projects = Project.visible.sorted.donate_project
      end
    end
  end

  private

  def set_per
    params[:per] = 4
  end

end
