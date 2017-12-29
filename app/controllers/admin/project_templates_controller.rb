class Admin::ProjectTemplatesController < Admin::BaseController
  before_action :set_project_template, only: [:show, :edit, :update, :destroy]

  def index
    @search = ProjectTemplate.roots.sorted.ransack(params[:q])
    scope = @search.result
    @project_templates = scope.page(params[:page])
  end

  def show
  end

  def new
    @project_template = ProjectTemplate.new
  end

  def edit
  end

  def create
    @project_template = ProjectTemplate.new(project_template_params)

    respond_to do |format|
      if @project_template.save
        format.html { redirect_to admin_project_templates_path, notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @project_template.update(project_template_params)
        format.html { redirect_to admin_project_templates_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @project_template.destroy
    respond_to do |format|
      format.html { redirect_to admin_project_templates_path, notice: '删除成功。' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_template
      @project_template = ProjectTemplate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_template_params
      params.require(:project_template).permit!
    end
end
