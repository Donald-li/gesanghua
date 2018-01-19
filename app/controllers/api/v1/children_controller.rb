class Api::V1::ChildrenController < Api::V1::BaseController
  before_action :set_pair

  def index
    @children = ProjectSeasonApplyChild.pass.outside.show.sorted
    @children = @children.where(city: params[:city]) if params[:city].present?
    @children = @children.where(district: params[:district]) if params[:district].present?
    api_success(data: {children: @children.map{|child| child.detail_builder}, info: @pair.detail_builder})
  end

  def get_address_list
    api_success(data: ProjectSeasonApplyChild.address_group)
  end

  def complaint
    @complaint = Complaint.new(complaint_params)
    @child = ProjectSeasonApplyChild.find(params[:child_id])
    @complaint.owner = @child
    complaint = Complaint.find_by(contact_phone: complaint_params[:contact_phone], owner: @child)
    if complaint.present?
      api_success(message: '您已经提交过举报信息')
    elsif @complaint.save
      api_success(message: '举报成功，管理员会尽快处理')
    else
      api_success(message: '提交失败，请重试')
    end
  end

  private
  def set_pair
    @pair = Project.first
  end

  def complaint_params
    params.require(:complaint).permit!
  end

end
