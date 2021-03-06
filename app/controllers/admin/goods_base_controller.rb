class Admin::GoodsBaseController < Admin::BaseController
  before_action :set_current_project, :get_current_project

  protected
  def set_current_project
    session[:goods_project_id] = params[:pid] if params[:pid].present?
  end

  def get_current_project
    @current_project ||= Project.where(kind: ['goods', 'donate']).find_by(id: session[:goods_project_id]) if session[:goods_project_id]
  end
end
