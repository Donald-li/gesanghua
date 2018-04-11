# 志愿者指派任务管理
class Admin::AppointTasksController < Admin::BaseController
  before_action :auth_manage_operation
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @search = Task.appoint.sorted.ransack(params[:q])
    scope = @search.result
    @tasks = scope.page(params[:page])
  end

  def show
    @search = @task.task_volunteers.sorted.ransack(params[:q])
    scope = @search.result
    @task_volunteers = scope.page(params[:page])
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params.merge(kind: 'appoint', num: params[:appoint_ids].size, state: 'close'))
    respond_to do |format|
      if @task.save
        params[:appoint_ids].each do |appoint_id|
          @task.task_volunteers.create(volunteer_id: appoint_id, state: 'pass', approve_time: Time.now, kind: 'appoint')
        end
        @task.attach_cover(params[:cover_id])
        format.html { redirect_to admin_appoint_tasks_path, notice: '新建成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        @task.attach_cover(params[:cover_id])
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
