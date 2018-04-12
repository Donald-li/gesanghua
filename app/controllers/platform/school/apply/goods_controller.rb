class Platform::School::Apply::GoodsController < Platform::School::BaseController
  before_action :set_goods_project
  def index
  end

  private
  def set_goods_project
    @current_project ||= Project.goods.visible.find(params[:pid])
  end
end
