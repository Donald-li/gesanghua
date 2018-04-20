class Admin::DonateStatisticsController < Admin::BaseController
  before_action :auth_manage_operation

  def show
    @search = User.sorted.ransack(params[:q])
    scope = @search.result.order(donate_amount: :desc).limit(200)
    @donate_statistics = scope.page(params[:page])
  end

  def excel_output
    path = ExcelOutput.donate_statistics_output
    send_file(path, filename: "用户捐助统计.xlsx")
  end

end
