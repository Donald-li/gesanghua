# 支出记录
class Admin::ExpenditureRecordsController < Admin::BaseController

  before_action :set_record, only: [:show, :edit, :update, :destroy]

  def index
    set_search_end_of_day(:expended_at_lteq)
    @search = ExpenditureRecord.sorted.ransack(params[:q])
    scope = @search.result

    respond_to do |format|
      format.html { @expenditure_records = scope.page(params[:page]) }
      format.xlsx {
        @expenditure_records = scope.sorted.all
        OperateLog.create_export_excel(current_user, '支出记录')
        response.headers['Content-Disposition'] = 'attachment; filename= "支出记录" ' + Date.today.to_s + '.xlsx'
      }
    end
  end

  def show
  end

  def new
    @expenditure_record = ExpenditureRecord.new
  end

  def edit
  end

  def create
    @expenditure_record = ExpenditureRecord.new(expenditure_record_params)
    @expenditure_record.attach_images(params[:image_ids])
    # @expenditure_record.administrator_id = current_user.id
    respond_to do |format|
      if @expenditure_record.save
        format.html { redirect_to referer_or(admin_expenditure_records_path), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @expenditure_record.attach_images(params[:image_ids])
    respond_to do |format|
      if @expenditure_record.update(expenditure_record_params)
        format.html { redirect_to referer_or(admin_expenditure_records_path), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def template_download
    path = ExcelOutput.generate_expenditure_template
    send_file(path, filename: "支出导入模板.xlsx")
  end

  def excel_import
    respond_to do |format|
      if notice =  ExpenditureRecord.read_excel(params[:expenditure_record_excel_id])
        format.html {redirect_to referer_or(admin_expenditure_records_path), notice: notice}
      else
        format.html {render :excel_upload}
      end
    end
  end

  def destroy
    @expenditure_record.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_expenditure_records_path), notice: '删除成功。' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_record
      @expenditure_record = ExpenditureRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expenditure_record_params
      params.require(:expenditure_record).permit!
    end
end
