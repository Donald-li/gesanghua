class Api::V1::ChildrenController < Api::V1::BaseController
  before_action :set_pair

  def index
    @children = ProjectSeasonApplyChild.where(id: ProjectSeasonApplyChild.visible_child_ids).sorted
    @children = @children.where(city: params[:city]) if params[:city].present?
    @children = @children.where(district: params[:district]) if params[:district].present?
    @children = @children.page(params[:page]).per(params[:per])
    api_success(data: {children: @children.map{|child| child.detail_builder}, info: @pair.detail_builder, pagination: json_pagination(@children)}) if @children.present?
    # api_success(data: {children: {}}, message: '没有可捐助孩子')
  end

  def get_address_list
    api_success(data: ProjectSeasonApplyChild.address_group)
  end

  private
  def set_pair
    @pair = Project.first
  end

end
