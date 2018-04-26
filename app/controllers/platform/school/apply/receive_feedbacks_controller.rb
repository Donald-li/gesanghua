class Platform::School::Apply::ReceiveFeedbacksController < Platform::School::BaseController

  def new
    if params[:apply_id].present?
      apply = ProjectSeasonApply.find(params[:apply_id])
      @receive = ReceiveFeedback.new(owner: apply)
    end
  end

  def create
    apply = ProjectSeasonApply.find(receive_feedback_params[:owner_id])
    @receive = ReceiveFeedback.new(receive_feedback_params.merge(owner: apply, user_id: current_user.id, project_id: apply.project.id, project_season_apply_id: apply.id, school_id: current_user.teacher.school.id))
    if @receive.save
      @receive.attach_images(params[:image_ids])
      apply.to_feedback!
      @project = @receive.owner.project if @receive.owner.present?
      if @project == Project.read_project
        redirect_to platform_school_apply_reads_path, notice: '反馈提交成功'
      elsif @project.goods?
        redirect_to platform_school_apply_goods_projects_path(pid: @project.id), notice: '反馈提交成功'
      end
    else
      render :new, notice: '反馈提交失败，请重试'
    end
  end

  private
  def receive_feedback_params
    params.require(:receive_feedback).permit!
  end

end
