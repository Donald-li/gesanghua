class Admin::CampDocumentBaseController < Admin::BaseController
  before_action :set_current_camp, :get_current_camp, :switch_camp

  protected
  def set_current_camp
    session[:camp_id] = params[:current_camp] if params[:current_camp].present?
  end

  def get_current_camp
    @current_camp ||= ProjectSeason.find_by(id: session[:camp_id]) if session[:camp_id]
  end

  def switch_camp
    unless @current_camp
      redirect_to admin_project_camp_seasons_url(return_camp: controller_path), notice: '请选择批次'
    end
  end
end
