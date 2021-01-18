class Admin::TaskAchievementsController < Admin::BaseController
  before_action :set_task_achievement, only: [:show, :edit, :update]

  def index
    @search = TaskVolunteer.where.not(task_id: nil).sorted.where(state: [:pass, :to_check, :done, :cancel, :turn_over]).ransack(params[:q])
    scope = @search.result.includes(:volunteer, :task)
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
    @task_achievement.state = 'done'
    @task_achievement.user = current_user
    respond_to do |format|
      if @task_achievement.save
        format.html { redirect_to referer_or(admin_task_achievements_path), notice: '审核成功。' }
      else
        format.html { redirect_to referer_or(admin_task_achievements_path), notice: '审核失败。' }
      end
    end
  end

  def switch_edit
    @task_volunteer = TaskVolunteer.find(params[:id])
    store_referer
  end

  def switch_update
    @task_volunteer = TaskVolunteer.find(params[:id])
    tv = TaskVolunteer.new(task: @task_volunteer.task, volunteer_id: params[:appoint_id], state: 'pass', kind: 'appoint')
    respond_to do |format|
      if @task_volunteer.update(state: 'turn_over') && tv.save
        format.html { redirect_to referer_or(admin_task_achievements_path), notice: '移交成功。' }
      else
        format.html { redirect_to referer_or(admin_task_achievements_path), notice: '移交失败。' }
      end
    end
  end

  def switch_finish
    @task_volunteer = TaskVolunteer.find(params[:id])
    respond_to do |format|
      if @task_volunteer.update(state: 'done',finish_time: Time.now)
        format.html { redirect_to referer_or(admin_task_achievements_path), notice: '标记任务完成成功。' }
      else
        format.html { redirect_to referer_or(admin_task_achievements_path), notice: '标记任务完成失败。' }
      end
    end
  end

  def switch
    @task_volunteer = TaskVolunteer.find(params[:id])
    respond_to do |format|
      if @task_volunteer.cancel!
        format.html { redirect_to referer_or(admin_task_achievements_path), notice: '取消成功。' }
      else
        format.html { redirect_to referer_or(admin_task_achievements_path), notice: '取消失败。' }
      end
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_task_achievement
    @task_achievement = TaskVolunteer.find(params[:id])
  end

end
