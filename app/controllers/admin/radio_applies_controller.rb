class Admin::RadioAppliesController < Admin::BaseController
  before_action :set_project_apply, only: [:show, :edit, :update, :destroy, :check]

  def index
    @search = ProjectSeasonApply.where(project_id: ProjectSeason.radio_project_id).sorted.ransack(params[:q])
    scope = @search.result
    @project_applies = scope.page(params[:page])
  end

  def show
  end

  def new
    @project_apply = ProjectSeasonApply.new
    @project_apply.build_radio_information
  end

  def edit
    @child_search = BeneficialChild.where(project_season_apply: @project_apply).sorted.ransack(params[:q])
    scope = @child_search.result
    @children = scope.page(params[:page])
    respond_to do |format|
      format.html { render :edit }
    end
  end

  def create
    @project_apply = ProjectSeasonApply.new(project_apply_params)
    @radio = @project_apply.build_radio_information(project_apply_params[:radio_information_attributes])
    respond_to do |format|
      if @project_apply.save
        @project_apply.attach_images(params[:image_ids])
        format.html { redirect_to admin_radio_applies_path, notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @project_apply.update(project_apply_params)
        @project_apply.attach_images(params[:image_ids])
        format.html { redirect_to admin_radio_applies_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @project_apply.destroy
    respond_to do |format|
      format.html { redirect_to admin_radio_applies_path, notice: '删除成功。' }
    end
  end

  def check
    respond_to do |format|
      audit_state = project_apply_params[:audit_state]
      @project_apply.audit_state = audit_state
      if @project_apply.save
        @project_apply.audits.create(state: audit_state, user_id: current_user.id, comment: project_apply_params[:approve_remark])
        format.html { redirect_to admin_radio_applies_path, notice: '审核成功' }
      else
        format.html { render :check }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_apply
      @project_apply = ProjectSeasonApply.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_apply_params
      params.require(:project_season_apply).permit!
    end
end
