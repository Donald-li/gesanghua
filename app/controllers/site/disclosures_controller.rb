class Site::DisclosuresController < Site::BaseController
  before_action :set_report, only: [:show, :file_download]

  def index
    scope = FinancialReport.show.sorted
    @financial_reports = scope.page(params[:page]).per(12)
  end

  def show
  end

  def file_download
    file = @financial_report.report_files.find(params[:file_id])
    send_file(File.join(Rails.root, 'public', file.file_url), filename: file.file_name)
  end

  private

  def set_report
    @financial_report = FinancialReport.find(params[:id])
  end
end
