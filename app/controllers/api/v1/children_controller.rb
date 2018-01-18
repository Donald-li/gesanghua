class Api::V1::ChildrenController < Api::V1::BaseController
  before_action :set_pair

  def index
    @children = ProjectSeasonApplyChild.pass.outside.show.sorted
    api_success(data: {children: @children.map{|child| child.detail_builder}, info: @pair.summary_builder})
  end

  def get_address_list
    api_success(data: ProjectSeasonApplyChild.address_group)
  end

  private
  def set_pair
    @pair = Project.first
  end

end
