class Admin::TaskAppliesController < Admin::BaseController
  before_action :set_task_apply, only: [:edit, :update]
  before_action :set_task

  def index
    @search = TaskVolunteer.where(task: @task).submit.sorted.ransack(params[:q])
    scope = @search.result
    @task_applies = scope.page(params[:page])
  end

  def edit
  end

  def update
    respond_to do |format|
      state = task_apply_params[:approve_state] == 'pass' ? 2 : 3
      if @task_apply.update(approve_state: state, approve_time: Time.now)
        @task_apply.audits.create(state: state, user_id: current_user.id, comment: params[:approve_remark])
        format.html { redirect_to admin_task_task_applies_path(@task), notice: '审核成功。' }
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
