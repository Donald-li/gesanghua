class Admin::PairStudentsController < Admin::BaseController
  before_action :set_project_apply

  def index
    @search = @project_apply.children.sorted.ransack(params[:q])
    scope = @search.result
    @children = scope.page(params[:page])
  end

  def show
  end

  def new
    @apply_child = @project_apply.children.build
  end

  def edit
    @apply_child = ProjectSeasonApplyChild.find(params[:id])
    @audit = @apply_child.audits.last
    @new_audit = @apply_child.audits.build
  end

  def create
    @apply_child = @project_apply.children.build(apply_child_params.merge(province: @project_apply.province, city: @project_apply.city, district: @project_apply.district, approve_state: 1))
    @apply_child.audits.build
    respond_to do |format|
      if @apply_child.save
        @apply_child.count_age
        format.html { redirect_to admin_pair_apply_pair_students_path(@project_apply), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @apply_child = ProjectSeasonApplyChild.find(params[:id])
    respond_to do |format|
      if @apply_child.update(apply_child_params)
        @apply_child.count_age
        format.html { redirect_to admin_pair_apply_pair_students_path(@project_apply), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @apply_child = ProjectSeasonApplyChild.find(params[:id])

    @apply_child.destroy
    respond_to do |format|
      format.html { redirect_to admin_pair_apply_pair_students_path(@project_apply), notice: '删除成功。' }
    end
  end

  def remarks
    @apply_child = ProjectSeasonApplyChild.find(params[:id])
    @search = @apply_child.remarks.sorted.ransack(params[:q])
    scope = @search.result
    @remarks = scope.page(params[:page])
  end

  def new_audit
    @apply_child = ProjectSeasonApplyChild.find(params[:id])
    @audit = @apply_child.audits.build
  end

  def create_audit
    @apply_child = ProjectSeasonApplyChild.find(params[:audit][:pair_student_id])
    @new_audit = @apply_child.audits.build(state: params[:audit][:state], comment: params[:audit][:comment], user_id: current_user.id)
    respond_to do |format|
      if @new_audit.save
        # if @audit.pass? && @apply_child.gsh_child.blank?
        #   @apply_child.build_gsh_child(name: @apply_child.name, phone: @apply_child.phone, idcard: @apply_child.id_card, province: @apply_child.province, city: @apply_child.city, district: @apply_child.district)
        # end
        #
        params[:audit][:state] == 'pass' ? @apply_child.approve_pass : @apply_child.approve_reject
        format.js
      else
        format.html { render :new_audit }
      end
    end
  end

  def edit_audti
    @apply_child = ProjectSeasonApplyChild.find(params[:id])
    @audit = @apply_child.audits.last
  end

  def update_audit
    @apply_child = ProjectSeasonApplyChild.find(params[:audit][:pair_student_id])
    @audit = @apply_child.audits.last
    respond_to do |format|
      if @audit.update(state: params[:audit][:state], comment: params[:audit][:comment], user_id: current_user.id)
        params[:audit][:state] == 'pass' ? @apply_child.approve_pass : @apply_child.approve_reject
        format.js
      else
        format.html { render :edit }
      end
    end
  end

  private
    def set_project_apply
      @project_apply = ProjectSeasonApply.find(params[:pair_apply_id])
    end

    def apply_child_params
      params.require(:project_season_apply_child).permit!
    end
end
