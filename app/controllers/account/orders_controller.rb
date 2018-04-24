class Account::OrdersController < Account::BaseController

  before_action :set_per

  def index
    respond_to do |format|
      format.html do
        @donate_records = DonateRecord.select_record(current_user.id, params[:type])
        @donate_records = @donate_records.where(project_id: params[:project_id]) if params[:project_id].present?
        @donate_records = @donate_records.sorted.page(params[:page]).per(8)
        @projects = Project.visible.sorted.donate_project
      end
    end
  end

  private

  def set_per
    params[:per] = 4
  end

end
