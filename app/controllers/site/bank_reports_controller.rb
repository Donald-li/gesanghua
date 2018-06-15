class Site::BankReportsController < Site::BaseController
  before_action :set_report, only: [:show, :file_download]

  def index
    scope = BankReport.show.sorted
    @bank_reports = scope.page(params[:page]).per(12)
  end

  def show
  end

  def file_download
    file = @bank_report.report_files.find(params[:file_id])
    send_file(File.join(Rails.root, 'public', file.file_url), filename: file.file_name)
  end

  private
  def set_report
    @bank_report = BankReport.find(params[:id])
  end
end
