class Admin::BankReportsController < Admin::BaseController

  before_action :set_bank_report, only: [:show, :edit, :update, :destroy, :switch, :file_download]

  def index
    @search = BankReport.sorted.ransack(params[:q])
    scope = @search.result
    @bank_reports = scope.page(params[:page])
  end

  def show
  end

  def new
    @bank_report = BankReport.new
  end

  def edit
  end

  def create
    @bank_report = BankReport.new(bank_report_params)
    @bank_report.user_id = current_user.id
    respond_to do |format|
      if @bank_report.save
        @bank_report.attach_report_files(params[:file_ids])
        format.html { redirect_to referer_or(admin_bank_reports_path), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      @bank_report.attach_report_files(params[:file_ids])
      if @bank_report.update(bank_report_params)
        format.html { redirect_to referer_or(admin_bank_reports_path), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @bank_report.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_bank_reports_path), notice: '删除成功。' }
    end
  end

  def switch
    @bank_report.show? ? @bank_report.hidden! : @bank_report.show!
    redirect_to referer_or(admin_bank_reports_path), notice:  @bank_report.show? ? '报告已显示' : '报告已隐藏'
  end

  def file_download
    file = @bank_report.report_files.find(params[:file_id])
    send_file(File.join(Rails.root, 'public', file.file_url), filename: file.file_name)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_bank_report
    @bank_report = BankReport.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bank_report_params
    params.require(:bank_report).permit!
  end
end
