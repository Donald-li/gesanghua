class Admin::AppointTasksController < Admin::BaseController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :switch_edit, :switch_update, :check_edit, :check_update]

  def index
    @search = Task.appoint.sorted.ransack(params[:q])
    scope = @search.result
    @tasks = scope.page(params[:page])
  end

  def show
    @task_volunteers = @task.task_volunteers
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params.merge(kind: 2, num: params[:appoint_ids].size, state: 5))
    respond_to do |format|
      if @task.save
        params[:appoint_ids].each do |appoint_id|
          @task.task_volunteers.create(volunteer_id: appoint_id, approve_state: 'pass', approve_time: Time.now)
        end
        format.html { redirect_to admin_tasks_path, notice: '新建成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to admin_tasks_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to admin_tasks_path, notice: '删除成功。' }
    end
  end

  def switch_edit
    @task_volunteer = TaskVolunteer.find(params[:task_volunteer_id])
  end

  def switch_update
    @task_volunteer = TaskVolunteer.find(params[:task_volunteer_id])
    respond_to do |format|
      if @task_volunteer.update(volunteer_id: params[:appoint_id])
        format.html { redirect_to admin_task_path(@task), notice: '移交成功。' }
      else
        format.html { redirect_to admin_task_path(@task), notice: '移交失败。' }
      end
    end
  end

  def check_edit
  end

  def check_update
    respond_to do |format|
      @task.task_volunteers.first.update!(duration: params[:duration], comment: params[:comment], finish_state: 'done', finish_time: Time.now)
      if @task.done!
        format.html { redirect_to admin_tasks_path, notice: '审核成功。' }
      else
        format.html { redirect_to admin_tasks_path, notice: '审核失败。' }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit!
  end
end
