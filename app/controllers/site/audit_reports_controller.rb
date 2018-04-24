class Site::AuditReportsController < Site::BaseController
  before_action :set_report, only: [:show, :file_download]

  def index
    scope = AuditReport.show.sorted
    @audit_reports = scope.page(params[:page]).per(12)
  end

  def show
  end

  def file_download
    file = @audit_report.report_files.find(params[:file_id])
    send_file(File.join(Rails.root, 'public', file.file_url), filename: file.file_name)
  end

  private
  def set_report
    @audit_report = AuditReport.find(params[:id])
  end
end
