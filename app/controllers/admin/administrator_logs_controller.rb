# 登录日志
class Admin::AdministratorLogsController < Admin::BaseController

  def index
    set_search_end_of_day(:created_at_lteq)
    @search = AdministratorLog.ransack(params[:q])
    scope = @search.result
    respond_to do |format|
      format.html {
        @administrator_logs = scope.sorted.page(params[:page])
      }
      format.xlsx {
        @administrator_logs = scope.sorted.all
        OperateLog.create_export_excel(current_user, "登录记录")
        response.headers['Content-Disposition'] = 'attachment; filename= "登录记录" ' + Date.today.to_s + '.xlsx'
      }
    end

  end

end
