class Admin::TasksController < Admin::BaseController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :switch]

  def index
    @search = Task.sorted.ransack(params[:q])
    scope = @search.result
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
        format.html { redirect_to admin_tasks_path, notice: '发布成功。' }
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

  def switch
    @task.state = params[:state]
    respond_to do |format|
      if @task.save
        format.html { redirect_to admin_tasks_path, notice: '标记成功。' }
      else
        format.html { redirect_to admin_tasks_path, notice: '标记失败。' }
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
