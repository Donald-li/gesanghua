class Admin::FinancialReportsController < Admin::BaseController

  before_action :set_financial_report, only: [:show, :edit, :update, :destroy, :switch, :file_download]

  def index
    @search = FinancialReport.sorted.ransack(params[:q])
    scope = @search.result
    @financial_reports = scope.page(params[:page])
  end

  def show
  end

  def new
    @financial_report = FinancialReport.new
  end

  def edit
  end

  def create
    @financial_report = FinancialReport.new(financial_report_params)
    @financial_report.user_id = current_user.id
    respond_to do |format|
      if @financial_report.save
        @financial_report.attach_report_files(params[:file_ids])
        format.html { redirect_to referer_or(admin_financial_reports_path), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      @financial_report.attach_report_files(params[:file_ids])
      if @financial_report.update(financial_report_params)
        format.html { redirect_to referer_or(admin_financial_reports_path), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @financial_report.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_financial_reports_path), notice: '删除成功。' }
    end
  end

  def switch
    @financial_report.show? ? @financial_report.hidden! : @financial_report.show!
    redirect_to referer_or(admin_financial_reports_path), notice:  @financial_report.show? ? '报告已显示' : '报告已隐藏'
  end

  def file_download
    file = @financial_report.report_files.find(params[:file_id])
    send_file(File.join(Rails.root, 'public', file.file_url), filename: file.file_name)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_financial_report
    @financial_report = FinancialReport.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def financial_report_params
    params.require(:financial_report).permit!
  end
end
