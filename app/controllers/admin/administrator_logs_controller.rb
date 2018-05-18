# 登录日志
class Admin::AdministratorLogsController < Admin::BaseController

  def index
    set_search_end_of_day(:created_at_lteq)
    @search = AdministratorLog.ransack(params[:q])
    scope = @search.result
    @administrator_logs = scope.sorted.page(params[:page])
  end

end
