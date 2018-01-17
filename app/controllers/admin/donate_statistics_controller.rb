class Admin::DonateStatisticsController < Admin::BaseController

  def show
    @search = User.sorted.ransack(params[:q])
    scope = @search.result
    @donate_statistics = scope.page(params[:page])
  end

  def excel_output
    ExcelOutput.donate_statistics_output
    file_path = Rails.root.join("public/files/用户捐助统计" + DateTime.now.strftime("%Y-%m-%d-%s") + ".xlsx")
    file_name = "用户捐助统计.xlsx"
    send_file(file_path, filename: file_name)
  end

end