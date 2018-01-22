class Api::V1::PairChildrenController < Api::V1::BaseController
  before_action :set_pair, only: [:show, :complaint, :contribute]

  def show
    api_error(message: '无效页面') && return unless @pair
    api_success(data: @pair.summary_builder)
  end

  def complaint
    api_error(message: '无效页面') && return unless @pair
    @complaint = Complaint.new(complaint_params)
    @complaint.owner = @pair
    complaint = Complaint.find_by(contact_phone: complaint_params[:contact_phone], owner: @pair)
    if complaint.present?
      api_success(message: '您已经提交过举报信息')
    elsif @complaint.save
      api_success(message: '举报成功，管理员会尽快处理')
    else
      api_success(message: '提交失败，请重试')
    end
  end

  def contribute
    api_error(message: '无效页面') && return unless @pair
    api_success(data: {child_info: @pair.detail_builder})
  end

  private

  def set_pair
    @pair = ProjectSeasonApplyChild.find(params[:id])
  end

  def complaint_params
    params.require(:complaint).permit!
  end

end
