class Admin::ReadAppliesController < Admin::BaseController
  before_action :set_project_apply, only: [:show, :edit, :update, :destroy, :audit, :students]

  def index
    @search = ProjectSeasonApply.where(project_id: 2).sorted.ransack(params[:q])
    scope = @search.result.joins(:school)
    @project_applies = scope.page(params[:page])
  end

  def show
  end

  def new
    @project_apply = ProjectSeasonApply.new
  end

  def edit
  end

  def create
    # @school = School.find(project_apply_params[:school_id])
    @project_apply = ProjectSeasonApply.new(project_apply_params.merge(project_id: 2))
    @project_apply.attach_images(params[:image_ids])
    @project_apply.audits.build
    respond_to do |format|
      if ProjectSeasonApply.find_by(school_id: project_apply_params[:school_id], project_id: 2).present?
        flash[:notice] = '此学校在本批次还有未完成的申请'
        format.html { render :new }
      elsif @project_apply.save!
        @project_apply.gsh_bookshelves.update_all(school_id: @project_apply.school_id, project_season_id: @project_apply.project_season_id)
        format.html { redirect_to admin_read_applies_path, notice: '创建成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @project_apply.update(project_apply_params)
        format.html { redirect_to admin_read_applies_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def audit
    @audit = @project_apply.audits.last
    @new_audit = @project_apply.audits.build
  end

  def create_audit
    @project_apply = ProjectSeasonApply.find(params[:audit][:apply_id])
    @new_audit = @project_apply.audits.build(state: params[:audit][:state], comment: params[:audit][:comment], user_id: current_user.id)
    respond_to do |format|
      if @new_audit.save
        @project_apply.update_columns(audit_state: params[:audit][:state])
        format.js
      else
        format.html { render :audit }
      end
    end
  end

  def destroy
    @project_apply.destroy
    respond_to do |format|
      format.html { redirect_to admin_read_applies_path, notice: '删除成功。' }
    end
  end

  def students
    @search = @project_apply.beneficial_children.sorted.ransack(params[:q])
    @bookshelves = @project_apply.gsh_bookshelves
    scope = @search.result
    @students = scope.page(params[:page])
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
