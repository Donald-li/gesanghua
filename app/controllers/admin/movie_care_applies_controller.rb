class Admin::MovieCareAppliesController < Admin::BaseController
  before_action :check_auth
  before_action :set_project_apply, only: [:show, :edit, :update, :destroy, :check]

  def index
    @search = ProjectSeasonApply.where(project_id: Project.movie_care_project.id).sorted.ransack(params[:q])
    scope = @search.result
    @project_applies = scope.page(params[:page])
  end

  def show
    store_referer
  end

  def new
    @project_apply = ProjectSeasonApply.new
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
    respond_to do |format|
      if ProjectSeasonApply.find_by(school_id: project_apply_params[:school_id], project_season_id: project_apply_params[:project_season_id], project_id: Project.movie_care_project.id).present?
        flash[:notice] = '此学校在本批次还有未完成的申请'
        format.html { render :new }
      elsif @project_apply.save
        @project_apply.attach_images(params[:image_ids])
        format.html { redirect_to referer_or(admin_movie_care_applies_path), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @project_apply.update(project_apply_params)
        @project_apply.attach_images(params[:image_ids])
        format.html { redirect_to referer_or(admin_movie_care_applies_path), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @project_apply.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_movie_care_applies_path), notice: '删除成功。' }
    end
  end

  def check
    respond_to do |format|
      audit_state = project_apply_params[:audit_state] == 'pass' ? 'pass' : 'reject'
      @project_apply.audit_state = audit_state
      if @project_apply.save
        if audit_state == 'reject'
          notice = Notification.create(
              kind: 'approve_reject',
              owner: @project_apply,
              user_id: @project_apply.school.try(:user_id),
              title: '审核通知',
              content: "您的护花项目申请审核未通过，原因：#{project_apply_params[:approve_remark]}",
              url: "#{Settings.m_root_url}/cooperation/school/main"
          )
        end
        @project_apply.audits.create(state: audit_state, user_id: current_user.id, comment: project_apply_params[:approve_remark])
        format.html { redirect_to referer_or(admin_movie_care_applies_path), notice: '审核成功' }
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

  def check_auth
    auth_operate_project(Project.movie_care_project)
  end
end
