class Admin::VouchersController < Admin::BaseController
  before_action :set_voucher, only: [:edit, :update, :switch]

  def index
    set_search_end_of_day(:created_at_lteq)
    @search = Voucher.ransack(params[:q])
    scope = @search.result
    @vouchers = scope.sorted.page(params[:page])
  end

  def edit
    if @voucher.logistic.blank?
      @voucher.build_logistic
    end
  end

  def update
    respond_to do |format|
      if @voucher.update(voucher_params)
        format.html { redirect_to referer_or(admin_vouchers_url), notice: '收据信息已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def switch
    @voucher.pending? ? @voucher.deal! : @voucher.pending!
    redirect_to admin_vouchers_url, notice:  @voucher.pending? ? '收据状态变为未处理' : '收据状态变为已处理'
  end

  private
  def set_voucher
    @voucher = Voucher.find(params[:id])
  end

  def voucher_params
    params.require(:voucher).permit!
  end
end
