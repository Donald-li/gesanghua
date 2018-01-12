class Admin::TaskAchievementsController < Admin::BaseController
  before_action :set_task_achievement, only: [:show, :edit, :update]

  def index
    @search = TaskVolunteer.to_check.sorted.ransack(params[:q])
    scope = @search.result.joins(:task)
    scope = scope.where(task_id: params[:task_id]) if params[:task_id].present?
    @task_volunteers = scope.page(params[:page])
  end

  def show
  end

  def edit
    @task = @task_achievement.task
  end

  def update
    @task_achievement.duration = params[:duration]
    @task_achievement.comment = params[:comment]
    @task_achievement.finish_time = Time.now
    @task_achievement.finish_state = 'done'
    respond_to do |format|
      if @task_achievement.save # TODO : 无法同步更新统计
        format.html { redirect_to admin_task_achievements_path, notice: '审核成功。' }
      else
        format.html { redirect_to admin_task_achievements_path, notice: '审核失败。' }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_task_achievement
    @task_achievement = TaskVolunteer.find(params[:id])
  end

end
