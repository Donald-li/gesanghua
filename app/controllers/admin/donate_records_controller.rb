class Admin::DonateRecordsController < Admin::BaseController
  before_action :auth_manage_finanical
  before_action :set_user, only: [:index, :destroy]

  def index
    @donate_records = @user.donate_records
    set_search_end_of_day(:created_at_lteq)
    @search = @donate_records.ransack(params[:q])
    scope = @search.result
    @donate_records = scope.sorted.page(params[:page])
    # @donante_amount = @donate_records.sum(:amount)
  end

  # 退款
  def refund
    @donate_record = DonateRecord.find(params[:id])
    if @donate_record.can_refund? # && @donate_record.try(:apply).try(:can_refund?)
      @donate_record.do_refund!
      redirect_back fallback_location: admin_user_donate_records_url(@donate_record.donor_id), notice: '退款成功'
    else
      redirect_back fallback_location: admin_user_donate_records_url(@donate_record.donor_id), alert: '退款失败'
    end
  end

  def destroy
    @donate_record = DonateRecord.find(params[:id])
    @donate_record.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_user_donate_records_url(@user, @donate_record)), article: '捐助记录已删除。' }
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

end
