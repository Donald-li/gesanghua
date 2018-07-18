class Admin::OperateLogsController < Admin::BaseController

  def index
    set_search_end_of_day(:created_at_lteq)
    @search = OperateLog.ransack(params[:q])
    scope = @search.result
    @operate_logs = scope.sorted.page(params[:page])
  end

end
