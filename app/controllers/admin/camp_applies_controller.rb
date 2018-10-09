class Admin::CampAppliesController < Admin::BaseController
  before_action :set_project_apply, only: [:edit, :update, :show, :destroy, :check]

  def index
    @search = ProjectSeasonApply.where(project: Project.camp_project).sorted.ransack(params[:q])
    scope = @search.result
    @project_applies = scope.page(params[:page])
  end


  def show
    store_referer
  end

  def new
    @project_apply = ProjectSeasonApply.new(project: Project.camp_project)
  end

  def edit
  end

  def create
    @project_apply = ProjectSeasonApply.new(project_apply_params)
    respond_to do |format|
      if @project_apply.save
        @project_apply.attach_cover_image(params[:cover_image_id])
        format.html { redirect_to referer_or(admin_camp_applies_path), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @project_apply.update(project_apply_params)
        @project_apply.attach_cover_image(params[:cover_image_id])
        format.html { redirect_to referer_or(admin_camp_applies_path), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @project_apply.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_camp_applies_path), notice: '删除成功。' }
    end
  end

  def check
    respond_to do |format|
      audit_state = project_apply_params[:audit_state]
      @project_apply.audit_state = audit_state
      if @project_apply.save
        @project_apply.audits.create(state: audit_state, user_id: current_user.id, comment: project_apply_params[:approve_remark])
        format.html { redirect_to referer_or(admin_camp_applies_path), notice: '审核成功' }
      else
        format.html { render :check }
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
