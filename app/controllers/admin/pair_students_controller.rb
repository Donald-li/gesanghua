class Admin::PairStudentsController < Admin::BaseController
  before_action :set_project_apply

  def index
    @search = @project_apply.apply_children.sorted.ransack(params[:q])
    scope = @search.result
    @children = scope.page(params[:page])
  end

  def show
  end

  def new
    @apply_child = @project_apply.apply_children.build
  end

  def edit
    @apply_child = ProjectSeasonApplyChild.find(params[:id])
  end

  def create
    @apply_child = @project_apply.apply_children.build(apply_child_params.merge(province: @project_apply.province, city: @project_apply.city, district: @project_apply.district))
    # @apply_child.audits.build
    respond_to do |format|
      if @apply_child.save
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
    @audit = @apply_child.audits.build(state: params[:audit][:state], comment: params[:audit][:comment], user_id: current_user.id)
    respond_to do |format|
      if @audit.save
        if @audit.pass? && @apply_child.gsh_child.blank?
          @apply_child.build_gsh_child(name: @apply_child.name, phone: @apply_child.phone, idcard: @apply_child.id_card, province: @apply_child.province, city: @apply_child.city, district: @apply_child.district)
        end
        @apply_child.approve_state = params[:audit][:state]
        @apply_child.save(validate: false)
        format.html { redirect_to edit_admin_pair_apply_pair_student_path(@project_apply, @apply_child), notice: '审核成功。' }
      else
        format.html { render :new_audit }
      end
    end
  end

  # def switch
  #   @apply_child.enabled? ? @apply_child.disabled! : @apply_child.enabled!
  #   if @season.enabled?
  #     Pair.where.not(id: @season.id).update(state: 2)
  #   end
  #   redirect_to referer_or(admin_pair_seasons_path), notice: @season.enabled? ? "#{@season.name}年度已设为当前执行年度" : '该年度已禁用'
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_apply
      @project_apply = ProjectSeasonApply.find(params[:pair_apply_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def apply_child_params
      params.require(:project_season_apply_child).permit!
    end
end
