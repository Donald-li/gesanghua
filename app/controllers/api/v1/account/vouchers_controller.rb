class Api::V1::Account::VouchersController < Api::V1::BaseController

  def index
    vouchers = current_user.vouchers.sorted
    api_success(data: vouchers.map{|voucher| voucher.summary_builder})
  end

  def show
    voucher = Voucher.find(params[:id])
    api_success(data: voucher.detail_builder)
  end

  def apply_voucher
    @voucher = current_user.vouchers.build(voucher_params)
    ids = Array(params[:checked_records])
    if @voucher.save_voucher(current_user, ids)
      api_success(data: true, message: '提交成功')
    else
      api_error(message: "保存失败，#{@voucher.errors.full_messages.join(',')}")
    end
  end

  def address
    api_success(data: {location: [current_user.province, current_user.city, current_user.district], address: current_user.address})
  end

  private
  def voucher_params
    params.require(:voucher).permit!
  end

end
