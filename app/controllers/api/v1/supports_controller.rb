class Api::V1::SupportsController < Api::V1::BaseController

  def support_list
    supports = Support.wechat_support.show.sorted.page(params[:page]).per(params[:per_page])
    api_success(data: {supports: supports.map { |r| r.summary_builder }, pagination: json_pagination(supports)})
  end

  def show
    support = Support.find(params[:id])
    api_success(data: support.detail_builder)
  end

end
