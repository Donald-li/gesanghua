class Admin::TaskAppliesController < Admin::BaseController
  before_action :auth_manage_operation
  before_action :set_task_apply, only: [:edit, :update]
  before_action :set_task

  def index
    @search = TaskVolunteer.where(task: @task).sorted.ransack(params[:q])
    scope = @search.result.joins(:volunteer).where('volunteers.job_state' => 'available')
    @task_applies = scope.page(params[:page])
  end

  def edit
  end

  def update
    respond_to do |format|
      state = task_apply_params[:state] == 'pass' ? 'pass' : 'reject'
      if @task_apply.update(state: state, approve_time: Time.now)
        @task_apply.audits.create(state: state, user_id: current_user.id, comment: params[:approve_remark])

        owner = @task_apply
        if state == 'pass'
          title = "#任务申请# 审核已通过"
          content = "任务：#{@task_apply.task.try(:name)}申请已经审核通过。 "
        else
          title = "#任务申请# 审核未通过"
          content = "任务：#{@task_apply.task.try(:name)}申请审核未通过 未通过理由: #{params[:approve_remark]}"
        end
        notice = Notification.create(
            kind: state == 'pass' ? 'approve_pass' : 'approve_reject',
            owner: owner,
            user_id: owner.volunteer.user_id,
            title: title,
            content: content
        )

        format.html { redirect_to referer_or(admin_task_task_applies_path(@task)), notice: '审核成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_apply
      @task_apply = TaskVolunteer.find(params[:id])
    end

    def set_task
      @task = Task.find(params[:task_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_apply_params
      params.require(:task_volunteer).permit!
    end
end
