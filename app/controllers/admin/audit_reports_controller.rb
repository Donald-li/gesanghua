class Admin::AuditReportsController < Admin::BaseController
  before_action :set_audit_report, only: [:show, :edit, :update, :destroy, :switch, :file_download]

  def index
    @search = AuditReport.sorted.ransack(params[:q])
    scope = @search.result
    @audit_reports = scope.page(params[:page])
  end

  def show
  end

  def new
    @audit_report = AuditReport.new
  end

  def edit
  end

  def create
    @audit_report = AuditReport.new(audit_report_params)

    respond_to do |format|
      if @audit_report.save
        @audit_report.attach_report_files(params[:file_ids])
        format.html { redirect_to admin_audit_reports_path, notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      @audit_report.attach_report_files(params[:file_ids])
      if @audit_report.update(audit_report_params)
        format.html { redirect_to admin_audit_reports_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @audit_report.destroy
    respond_to do |format|
      format.html { redirect_to admin_audit_reports_path, notice: '删除成功。' }
    end
  end

  def switch
    @audit_report.show? ? @audit_report.hidden! : @audit_report.show!
    redirect_to admin_audit_reports_path, notice:  @audit_report.show? ? '报告已显示' : '报告已隐藏'
  end

  def file_download
    file = @audit_report.report_files.find(params[:file_id])
    send_file(File.join(Rails.root, 'public', file.file_url), filename: file.file_name)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_audit_report
      @audit_report = AuditReport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def audit_report_params
      params.require(:audit_report).permit!
    end
end
