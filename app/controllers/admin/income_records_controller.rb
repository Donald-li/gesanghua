class Admin::IncomeRecordsController < Admin::BaseController
  before_action :auth_manage_finanical
  before_action :set_income_record, only: [:show, :edit, :update, :destroy]

  def index
    set_search_end_of_day(:created_at_lteq)
    @search = IncomeRecord.sorted.ransack(params[:q])
    scope = @search.result
    respond_to do |format|
      format.html { @income_records = scope.page(params[:page]) }
      format.xlsx {
        @income_records = scope.sorted.all
        response.headers['Content-Disposition'] = 'attachment; filename= "收入记录" ' + Date.today.to_s + '.xlsx'
      }
    end
  end

  def show
  end

  def new
    @income_record = IncomeRecord.new
  end

  def edit
  end

  def create
    @income_record = IncomeRecord.new(income_record_params)
    user = User.find(income_record_params[:agent_id])
    @income_record.donor = user
    @income_record.kind = :offline
    # @income_record.remitter_name = user.name
    # @income_record.remitter_id = user.id
    @income_record.balance = income_record_params[:amount]
    respond_to do |format|
      if @income_record.save
        format.html { redirect_to referer_or(admin_income_records_path), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @income_record.update(income_record_params)
        format.html { redirect_to referer_or(admin_income_records_path), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @income_record.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_income_records_path), notice: '删除成功。' }
    end
  end

  def excel_upload
  end

  def template_download
    path = ExcelOutput.generate_income_template
    send_file(path, filename: "收入导入模板.xlsx")
  end

  def excel_import
    respond_to do |format|
      if IncomeRecord.read_excel(params[:income_record_excel_id])
        format.html {redirect_to referer_or(admin_income_records_path), notice: '操作成功'}
      else
        format.html {render :excel_upload}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_income_record
      @income_record = IncomeRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def income_record_params
      params.require(:income_record).permit!
    end

end
