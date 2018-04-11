class Admin::GoodsBaseController < Admin::BaseController
  before_action :set_current_project, :get_current_project

  protected
  def set_current_project
    session[:goods_project_id] = params[:pid] if params[:pid].present?
  end

  def get_current_project
    @current_project ||= Project.goods.find_by(id: session[:goods_project_id]) if session[:goods_project_id]
    auth_operate_project(@current_project)
  end
end
