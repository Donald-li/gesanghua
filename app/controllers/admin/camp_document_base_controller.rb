class Admin::CampDocumentBaseController < Admin::BaseController
  before_action :set_current_apply, :get_current_apply, :switch_apply

  protected
  def set_current_apply
    session[:apply_id] = params[:current_apply] if params[:current_apply].present?
  end

  def get_current_apply
    @current_apply ||= ProjectSeasonApply.find_by(id: session[:apply_id]) if session[:apply_id]
  end

  def switch_apply
    unless @current_apply
      redirect_to admin_camp_applies_url(return_apply: controller_path), notice: '请选择探索营'
    end
  end
end
