class Admin::PairStudentsController < Admin::BaseController
  before_action :set_project_apply
  before_action :set_apply_child, only: [:show, :edit, :update, :destroy, :check]

  def index
    @search = @project_apply.children.where(school: @project_apply.school).check_list.sorted.ransack(params[:q])
    scope = @search.result
    @children = scope.page(params[:page])
  end

  def show
  end

  def new
    @apply_child = @project_apply.children.build
  end

  def edit
    @audit = @apply_child.audits.last || @apply_child.audits.create
    @new_audit = @apply_child.audits.build(state: 2)
  end

  def create
    @apply_child = @project_apply.children.build(apply_child_params.merge(province: @project_apply.province, city: @project_apply.city, district: @project_apply.district, approve_state: 2))
    @apply_child.audits.build
    @apply_child.attach_images(params[:image_ids])
    @apply_child.attach_avatar(params[:avatar_id])
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
    @apply_child.attach_images(params[:image_ids])
    @apply_child.attach_avatar(params[:avatar_id])
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
    @apply_child.destroy
    respond_to do |format|
      format.html { redirect_to admin_pair_apply_pair_students_path(@project_apply), notice: '删除成功。' }
    end
  end

  def check
    respond_to do |format|
      approve_state = apply_child_params[:approve_state]
      @apply_child.approve_state = approve_state
      if @apply_child.save
        @apply_child.audits.create(state: approve_state, user_id: current_user.id, comment: apply_child_params[:approve_remark])
        if @apply_child.pass?
          @apply_child.approve_pass
        end
        format.html { redirect_to admin_pair_apply_pair_students_path(@project_apply), notice: '审核成功' }
      else
        format.html { render :check }
      end
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
        #   @apply_child.build_gsh_child(name: @apply_child.name, phone: @apply_child.phone, id_card: @apply_child.id_card, province: @apply_child.province, city: @apply_child.city, district: @apply_child.district)
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

    def set_apply_child
      @apply_child = ProjectSeasonApplyChild.find(params[:id])
    end
end
