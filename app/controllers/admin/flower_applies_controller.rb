class Admin::FlowerAppliesController < Admin::BaseController
  before_action :set_project, only: [:index, :new, :create]
  before_action :set_project_apply, only: [:show, :edit, :update, :destroy, :switch_to_raise, :audit, :check]

  def index
    @search = @project.applies.sorted.ransack(params[:q])
    scope = @search.result
    @project_applies = scope.page(params[:page])
  end

  def show
  end

  def new
    @project_apply = @project.applies.new
  end

  def edit
    @audit = @project_apply.audits.last || @project_apply.audits.create
    @new_audit = @project_apply.audits.build
    @child_search = BeneficialChild.where(project_season_apply: @project_apply).sorted.ransack(params[:q])
    scope = @child_search.result
    @children = scope.page(params[:page])
  end

  def create
    @school = School.find(project_apply_params[:school_id])
    @project_apply = @project.applies.new(project_apply_params.merge(project: @project))

    respond_to do |format|
      if ProjectSeasonApply.find_by(school_id: project_apply_params[:school_id], project_id: ProjectSeason.flower_project_id, project_season_id: project_apply_params[:project_season_id]).present?
        flash[:notice] = '此学校在本批次还有未完成的申请'
        format.html { render :new }
      elsif @project_apply.save
        @project_apply.update(apply_no: @project_apply.apply_no)
        @project_apply.attach_images(params[:apply_image_ids])
        @project_apply.audits.build
        format.html { redirect_to admin_flower_applies_path, notice: '创建成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @project_apply.update(project_apply_params)
        @project_apply.attach_images(params[:apply_image_ids])
        format.html { redirect_to admin_flower_applies_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @project_apply.destroy
    respond_to do |format|
      format.html { redirect_to admin_flower_applies_path, notice: '删除成功。' }
    end
  end

  def switch_to_raise
    # @project_apply.update(project_type: 2)
    redirect_to edit_admin_flower_project_path(@project_apply), notice: '请填写筹款项目信息！'
  end

  def audit
    @audit = @project_apply.audits.last
    @new_audit = @project_apply.audits.build
  end

  def new_audit
    @project_apply = ProjectSeasonApply.find(params[:id])
    @audit = @project_apply.audits.build
  end

  def create_audit
    @project_apply = ProjectSeasonApply.find(params[:audit][:project_season_apply_id])
    @new_audit = @project_apply.audits.build(state: params[:audit][:state], comment: params[:audit][:comment], user_id: current_user.id)
    respond_to do |format|
      if @new_audit.save
        params[:audit][:state] == 'pass' ? @project_apply.audit_pass : @project_apply.audit_reject
        format.js
      else
        format.html { render :new_audit }
      end
    end
  end

  def edit_audti
    @project_apply = ProjectSeasonApply.find(params[:id])
    @audit = @project_apply.audits.last
  end

  def update_audit
    @project_apply = ProjectSeasonApply.find(params[:audit][:project_season_apply_id])
    @audit = @project_apply.audits.last
    respond_to do |format|
      if @audit.update(state: params[:audit][:state], comment: params[:audit][:comment], user_id: current_user.id)
        params[:audit][:state] == 'pass' ? @project_apply.audit_pass : @project_apply.audit_reject
        format.js
      else
        format.html { render :edit }
      end
    end
  end

  def check
    respond_to do |format|
      audit_state = project_apply_params[:audit_state] == 'pass' ? 'pass' : 'reject'
      @project_apply.audit_state = audit_state
      if @project_apply.save
        @project_apply.audits.create(state: audit_state, user_id: current_user.id, comment: project_apply_params[:approve_remark])
        format.html { redirect_to admin_flower_applies_path, notice: '审核成功' }
      else
        format.html { render :check }
      end
    end
  end

  private
  def set_project
    @project = Project.care_project
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_project_apply
    @project_apply = ProjectSeasonApply.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_apply_params
    params.require(:project_season_apply).permit!
  end
end
