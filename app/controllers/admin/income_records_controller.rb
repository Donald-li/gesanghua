class Admin::IncomeRecordsController < Admin::BaseController
  before_action :set_income_record, only: [:show, :edit, :update, :destroy]

  def index
    set_search_end_of_day(:created_at_lteq)
    @search = IncomeRecord.sorted.ransack(params[:q])
    scope = @search.result.joins(:user)
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
    user = User.find(income_record_params[:user_id]).name
    @income_record.donor = user.name
    @income_record.remitter_name = user.name
    @income_record.remitter_id = user.id

    respond_to do |format|
      if @income_record.save
        format.html { redirect_to admin_income_records_path, notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @income_record.update(income_record_params)
        format.html { redirect_to admin_income_records_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @income_record.destroy
    respond_to do |format|
      format.html { redirect_to admin_income_records_path, notice: '删除成功。' }
    end
  end

  def excel_upload
  end

  def excel_import

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
