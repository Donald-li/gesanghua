class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected
  # 修改日期选择查询中最后一天
  def set_search_end_of_day(attr=:created_at_lteqeq)
    return unless params[:q]
    return unless params[:q][attr].present?
    params[:q][attr] = Date.parse(params[:q][attr].end_of_day)
  end
end
