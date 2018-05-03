class Admin::ReadAppliesController < Admin::BaseController
  before_action :check_auth
  before_action :set_project_apply, only: [:show, :edit, :update, :destroy, :audit, :students, :switch, :check]

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
    @school = School.find(project_apply_params[:school_id])
    @project_apply = ProjectSeasonApply.new(project_apply_params.merge(project_id: 2, bookshelf_type: 1))
    @project_apply.attach_images(params[:image_ids])
    @project_apply.audits.build
    respond_to do |format|
      if ProjectSeasonApply.find_by(school_id: @school.id, project_season_id: project_apply_params[:project_season_id], project_id: Project.read_project.id).present?
        flash[:notice] = '此学校在本批次还有未完成的申请'
        format.html { render :new }
      elsif @project_apply.save
        # bookshelf_univalence = @project_apply.season.bookshelf_univalence
      @project_apply.bookshelves.update_all(school_id: @school.id, project_season_id: @project_apply.project_season_id, project_id: Project.read_project.id, province: @school.province, city: @school.city, district: @school.district)
      @project_apply.target_amount = @project_apply.bookshelves.pass.sum(:target_amount).to_f
        format.html { redirect_to admin_read_applies_path, notice: '创建成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      @project_apply.attach_images(params[:image_ids])
      if @project_apply.update(project_apply_params)
        # bookshelf_univalence = @project_apply.season.bookshelf_univalence
        # @project_apply.bookshelves.update_all(school_id: @project_apply.school_id, project_season_id: @project_apply.project_season_id)
        if @project_apply.whole?
          @project_apply.target_amount = @project_apply.bookshelves.pass.sum(:target_amount).to_f
          @project_apply.save
        else
          @project_apply.target_amount = @project_apply.supplements.pass.sum(:target_amount).to_f
          @project_apply.save
        end
        format.html { redirect_to admin_read_applies_path, notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def check
    respond_to do |format|
      audit_state = project_apply_params[:audit_state]
      @project_apply.audit_state = audit_state
      @bookshelves = @project_apply.bookshelves
      @supplements = @project_apply.supplements
      if @project_apply.update(project_apply_params)
        @project_apply.audits.create(state: audit_state, user_id: current_user.id, comment: project_apply_params[:approve_remark])
        if @project_apply.pass?
          @bookshelves.where(audit_state: 'submit').update_all(audit_state: 'pass')
          @supplements.where(audit_state: 'submit').update_all(audit_state: 'pass')
        elsif @project_apply.reject?
          @bookshelves.update_all(audit_state: 'reject')
          @supplements.update_all(audit_state: 'reject')
        end
        format.html { redirect_to admin_read_applies_path, notice: '审核成功' }
      else
        format.html { render :check }
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
    respond_to do |format|
      if @project_apply.destroy
        format.html { redirect_to admin_read_applies_path, notice: '删除成功。' }
      else
        format.html { redirect_to admin_read_applies_path, notice: '请先删除该申请下的图书角。' }
      end
    end
  end

  def switch
    # @project_apply.raise_project!
    # @project_apply.gen_bookshelves_no
    if @project_apply.whole?
      redirect_to edit_admin_read_project_path(@project_apply), notice: '请填写筹款项目信息！'
    else
      redirect_to supply_edit_admin_read_project_path(@project_apply), notice: '请填写筹款项目信息！'
    end
  end

  def students
    @search = @project_apply.beneficial_children.sorted.ransack(params[:q])
    scope = @search.result
    @students = scope.page(params[:page])
  end

  def supply_new
    @project_apply = ProjectSeasonApply.new
  end

  def supply_create
    # @school = School.find(project_apply_params[:school_id])
    @project_apply = ProjectSeasonApply.new(project_apply_params.merge(project_id: 2, bookshelf_type: 2))
    @project_apply.attach_images(params[:image_ids])
    @project_apply.audits.build
    respond_to do |format|
      if ProjectSeasonApply.find_by(school_id: project_apply_params[:school_id], project_season_id: project_apply_params[:project_season_id], project_id: 2, bookshelf_type: 2).present?
        flash[:notice] = '此学校在本批次还有未完成的申请'
        format.html { render :supply_new }
      elsif @project_apply.save
        # @project_apply.bookshelves.update_all(school_id: @project_apply.school_id, project_season_id: @project_apply.project_season_id)
        @project_apply.target_amount = @project_apply.supplements.pass.sum(:target_amount).to_f
        @project_apply.save
        format.html { redirect_to admin_read_applies_path, notice: '创建成功。' }
      else
        format.html { render :supply_new }
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
    auth_operate_project(Project.read_project)
  end

end
