class Admin::PairDonateRecordsController < Admin::BaseController
  before_action :set_project

  def index
    @donate_records = @project.donate_records
    set_search_end_of_day(:created_at_lteq)
    @search = @donate_records.ransack(params[:q])
    scope = @search.result
    # @donante_amount = @donate_records.sum(:amount)
    respond_to do |format|
      format.html { @donate_records = scope.sorted.page(params[:page]) }
      format.xlsx {
        @donate_records = scope.sorted
        OperateLog.create_export_excel(current_user, '结对助学捐助记录')
        response.headers['Content-Disposition'] = 'attachment; filename="结对助学捐助记录"' + Date.today.to_s + '.xlsx'
      }
    end
  end

  def show
    @donate_record = DonateRecord.find(params[:id])
  end

  def destroy
    @donate_record = DonateRecord.find(params[:id])
    @donate_record.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_user_donate_records_url(@user,@donate_record)), notice: '捐助记录已删除。' }
    end
  end

  private

  def set_project
    @project = Project.pair_project

  end


end
