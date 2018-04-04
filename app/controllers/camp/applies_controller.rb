class Camp::AppliesController < Camp::BaseController
  before_action :set_project_apply, only: [:edit, :update, :show, :destroy, :switch]

  def index
    @search = current_user.camp.applies.where(project: Project.camp_project).sorted.ransack(params[:q])
    scope = @search.result
    @project_applies = scope.page(params[:page])
  end


  def show
  end

  def new
    @project_apply = ProjectSeasonApply.new(project: Project.camp_project)
  end

  def edit
  end

  def create
    @project_apply = ProjectSeasonApply.new(project_apply_params.merge(camp: current_user.camp, audit_state: 'draft'))
    respond_to do |format|
      if @project_apply.save
        @project_apply.attach_cover_image(params[:cover_image_id])
        format.html { redirect_to camp_applies_path, notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @project_apply.update(project_apply_params)
        @project_apply.attach_cover_image(params[:cover_image_id])
        format.html { redirect_to camp_applies_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @project_apply.destroy
    respond_to do |format|
      format.html { redirect_to camp_applies_path, notice: '删除成功。' }
    end
  end

  def switch
    respond_to do |format|
      if @project_apply.submit!
        format.html { redirect_to camp_applies_path, notice: '提交成功。' }
      else
        format.html { redirect_to camp_applies_path, notice: '提交失败，请重试。' }
      end
    end
  end

  private
  def set_project_apply
    @project_apply = ProjectSeasonApply.find(params[:id])
  end

  def project_apply_params
    params.require(:project_season_apply).permit!
  end

end
