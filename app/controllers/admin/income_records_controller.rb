class Admin::IncomeRecordsController < Admin::BaseController
  before_action :auth_manage_finanical
  before_action :set_income_record, only: [:show, :edit, :update, :destroy, :return_back]

  def index
    set_search_end_of_day(:created_at_lteq)
    @search = IncomeRecord.sorted.ransack(params[:q])
    scope = @search.result
    respond_to do |format|
      format.html {@income_records = scope.page(params[:page])}
      format.xlsx {
        @income_records = scope.sorted.all
        response.headers['Content-Disposition'] = 'attachment; filename= "收入记录" ' + Date.today.to_s + '.xlsx'
      }
    end
  end

  def show
  end

  def new
    @income_record = IncomeRecord.new(kind: 'offline')
  end

  def edit
  end

  def create
    @income_record = IncomeRecord.new(income_record_params)
    @income_record.agent = user if income_record_params[:agent_id].nil?
    @income_record.kind = :offline
    # @income_record.remitter_name = user.name
    # @income_record.remitter_id = user.id
    @income_record.balance = income_record_params[:amount]
    respond_to do |format|
      if @income_record.save
        format.html {redirect_to referer_or(admin_income_records_path), notice: '新增成功。'}
      else
        format.html {render :new}
      end
    end
  end

  def update
    respond_to do |format|
      if @income_record.update(income_record_params)
        format.html {redirect_to referer_or(admin_income_records_path), notice: '修改成功。'}
      else
        format.html {render :edit}
      end
    end
  end

  def destroy
    respond_to do |format|
      if @income_record.amount == @income_record.balance
        @income_record.destroy
        format.html {redirect_to referer_or(admin_income_records_path), notice: '删除成功。'}
      else
        format.html {redirect_to referer_or(admin_income_records_path), alert: '该收入记录已配捐，无法删除。'}
      end
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

  def return_back
    donor = @income_record.donor
    if AccountRecord.create(title: '财务收入记录退款', kind: 'refund', amount: @income_record.balance, user: donor, donor: donor, operator_id: current_user.id) && @income_record.update(balance: 0)
      redirect_to referer_or(edit_admin_income_record_path), notice: '操作成功'
    else
      redirect_to referer_or(edit_admin_income_record_path), notice: '操作失败'
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
