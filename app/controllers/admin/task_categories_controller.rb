class Admin::TaskCategoriesController < Admin::BaseController
  before_action :auth_manage_operation
  before_action :set_task_category, only: [:show, :edit, :update, :destroy]

  def index
    @search = TaskCategory.sorted.ransack(params[:q])
    scope = @search.result
    @task_categories = scope.page(params[:page])
  end

  def show
  end

  def new
    @task_category = TaskCategory.new
  end

  def edit
  end

  def create
    @task_category = TaskCategory.new(task_category_params)

    respond_to do |format|
      if @task_category.save
        format.html { redirect_to admin_task_categories_path, notice: '添加成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @task_category.update(task_category_params)
        format.html { redirect_to admin_task_categories_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @task_category.destroy
    respond_to do |format|
      format.html { redirect_to admin_task_categories_path, notice: '删除成功。' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_category
      @task_category = TaskCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_category_params
      params.require(:task_category).permit!
    end
end
