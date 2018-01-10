class Admin::AppointTasksController < Admin::BaseController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :switch_edit, :switch_update]

  def index
    @search = Task.appoint.sorted.ransack(params[:q])
    scope = @search.result
    @tasks = scope.page(params[:page])
  end

  def show
  end

  def new
    @task = Task.new(state: 'pick_done')
  end

  def edit
  end

  def create
    @task = Task.new(task_params.merge(kind: 2))
    respond_to do |format|
      if @task.save
        @task.task_volunteers.create(volunteer_id: params[:appoint_id], approve_state: 2, approve_time: Time.now)
        format.html { redirect_to admin_appoint_tasks_path, notice: '新建成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to admin_appoint_tasks_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to admin_appoint_tasks_path, notice: '删除成功。' }
    end
  end

  def switch_edit
  end

  def switch_update
    respond_to do |format|
      if @task.task_volunteers.first.update(volunteer_id: params[:appoint_id])
        format.html { redirect_to admin_appoint_tasks_path, notice: '移交成功。' }
      else
        format.html { redirect_to admin_appoint_tasks_path, notice: '移交失败。' }
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
