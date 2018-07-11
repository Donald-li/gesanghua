class Admin::TasksController < Admin::BaseController
  before_action :auth_manage_manpower
  before_action :set_task, only: [:show, :edit, :update, :destroy, :switch]

  def index
    @search = Task.sorted.normal.ransack(params[:q])
    scope = @search.result.includes(:workplace)
    @tasks = scope.page(params[:page])
  end

  def show
    @task_volunteers = @task.task_volunteers.pass.page(params[:page])
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    respond_to do |format|
      if @task.save
        @task.attach_cover(params[:cover_id])
        format.html { redirect_to referer_or(admin_tasks_path), notice: '发布成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        @task.attach_cover(params[:cover_id])
        format.html { redirect_to referer_or(admin_tasks_path), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_tasks_path), notice: '删除成功。' }
    end
  end

  def switch
    @task.state = params[:state]
    respond_to do |format|
      if @task.save
        format.html { redirect_to referer_or(admin_tasks_path), notice: '标记成功。' }
      else
        format.html { redirect_to referer_or(admin_tasks_path), notice: '标记失败。' }
      end
    end
  end

  def batch_manage
  end

  def send_message
    if params[:send_way] == 'total'
      user_ids = Volunteer.all.pluck(:user_id)
    else
      user_ids = Volunteer.where(id: params[:volunteer_ids]).pluck(:user_id)
    end
    if Task.send_messages(user_ids)
      redirect_to batch_manage_admin_tasks_path, notice: '发送成功。'
    else
      redirect_to batch_manage_admin_tasks_path, notice: '发送失败。'
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
