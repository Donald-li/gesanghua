class Api::V1::ChildrenController < Api::V1::BaseController
  before_action :set_pair

  def index
    @children = ProjectSeasonApplyChild.where(project: Project.pair_project).includes(:remarks, :gsh_child).pass.outside.show.sorted
    total = @children.count
    @children = @children.where(city: params[:city]) if params[:city].present?
    @children = @children.where(district: params[:district]) if params[:district].present?
    @children = @children.page(params[:page]).per(params[:per])
    api_success(data: {children: @children.map{|child| child.detail_builder if child.present?}, total: total, pagination: json_pagination(@children)})
  end

  def get_address_list
    api_success(data: ProjectSeasonApplyChild.address_group)
  end

  private
  def set_pair
    @pair = Project.first
  end

end
