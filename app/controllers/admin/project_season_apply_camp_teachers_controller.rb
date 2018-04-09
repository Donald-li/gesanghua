class Admin::ProjectSeasonApplyCampTeachersController < Admin::BaseController
  before_action :set_camp_teacher, only: [:edit, :update, :destroy, :show, :check]
  before_action :set_apply_camp

  def index
    @search = @apply_camp.camp_members.teacher.where(state: [:submit, :pass, :reject]).sorted.ransack(params[:q])
    scope = @search.result
    @camp_teachers = scope.page(params[:page])
  end

  def new
    @camp_teacher = ProjectSeasonApplyCampMember.new
  end

  def show
  end

  def create
    @camp_teacher = ProjectSeasonApplyCampMember.new(camp_teacher_params.merge(camp: @apply_camp.camp, apply: @apply_camp.apply, school: @apply_camp.school, apply_camp: @apply_camp, kind: 'teacher', state: 'submit'))
    respond_to do |format|
      if @camp_teacher.save
        @camp_teacher.attach_image(params[:image_id])
        format.html { redirect_to admin_project_season_apply_camp_teachers_path(apply_camp_id: @apply_camp.id), notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @camp_teacher.update(camp_teacher_params)
        @camp_teacher.attach_image(params[:image_id])
        format.html { redirect_to admin_project_season_apply_camp_teachers_path(apply_camp_id: @apply_camp.id), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @camp_teacher.destroy
    respond_to do |format|
      format.html { redirect_to admin_project_season_apply_camp_teachers_path(apply_camp_id: @apply_camp.id), notice: '删除成功。' }
    end
  end

  def check
    respond_to do |format|
      state = camp_teacher_params[:state]
      @camp_teacher.state = state
      if @camp_teacher.save
        @camp_teacher.audits.create(state: state, user_id: current_user.id, comment: camp_teacher_params[:approve_remark])
        format.html { redirect_to admin_project_season_apply_camp_teachers_path(apply_camp_id: @apply_camp.id), notice: '审核成功' }
      else
        format.html { render :show }
      end
    end
  end

  private
  def set_apply_camp
    @apply_camp = ProjectSeasonApplyCamp.find(params[:apply_camp_id])
  end

  def set_camp_teacher
    @camp_teacher = ProjectSeasonApplyCampMember.find(params[:id])
  end

  def camp_teacher_params
    params.require(:project_season_apply_camp_member).permit!
  end

end
