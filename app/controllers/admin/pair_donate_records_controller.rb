class Admin::PairDonateRecordsController < Admin::BaseController
  before_action :set_project, only: [:index, :show, :destroy]

  def index
    @donate_records = @project.donate_records.where(pay_state: [:paid, :refund])
    set_search_end_of_day(:created_at_lteq)
    @search = @donate_records.ransack(params[:q])
    scope = @search.result
    @donate_records = scope.sorted.page(params[:page])
    # @donante_amount = @donate_records.sum(:amount)
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
    @project = Project.first
  end

end
