class Api::V1::ChildrenController < Api::V1::BaseController
  before_action :set_pair

  def index
    @children = ProjectSeasonApplyChild.pass.outside.show.sorted
    @children = @children.where(city: params[:city]) if params[:city].present?
    @children = @children.where(district: params[:district]) if params[:district].present?
    @children = @children.page(params[:page]).per(params[:per])
    api_success(data: {children: @children.map{|child| child.detail_builder if child.present?}, info: @pair.detail_builder, pagination: json_pagination(@children)})
  end

  def get_address_list
    api_success(data: ProjectSeasonApplyChild.address_group)
  end

  private
  def set_pair
    @pair = Project.first
  end

end
