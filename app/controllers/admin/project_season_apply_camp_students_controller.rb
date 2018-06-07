class Admin::ProjectSeasonApplyCampStudentsController < Admin::BaseController
  before_action :check_auth
  before_action :set_camp_student, only: [:edit, :update, :destroy, :show, :check]
  before_action :set_apply_camp

  def index
    @search = @apply_camp.camp_members.student.where(state: [:submit, :pass, :reject]).sorted.ransack(params[:q])
    scope = @search.result
    @camp_students = scope.page(params[:page])
  end

  def new
    @camp_student = ProjectSeasonApplyCampMember.new
  end

  def show
    store_referer
  end

  def create
    @camp_student = ProjectSeasonApplyCampMember.new(camp_student_params.merge(camp: @apply_camp.camp, apply: @apply_camp.apply, school: @apply_camp.school, apply_camp: @apply_camp, kind: 'student', state: 'submit'))
    respond_to do |format|
      if ProjectSeasonApplyCampMember.allow_apply?(@apply_camp, camp_student_params[:id_card])
      if @camp_student.save
        @camp_student.attach_image(params[:image_id])
        format.html { redirect_to referer_or(admin_project_season_apply_camp_students_path(apply_camp_id: @apply_camp.id)), notice: '新增成功。' }
      else
        format.html { render :new }
      end
      else
        flash[:alert] = '身份证号已占用'
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if ProjectSeasonApplyCampMember.allow_apply?(@apply_camp, camp_student_params[:id_card], @camp_student)
      if @camp_student.update(camp_student_params)
        @camp_student.attach_image(params[:image_id])
        format.html { redirect_to referer_or(admin_project_season_apply_camp_students_path(apply_camp_id: @apply_camp.id)), notice: '修改成功。' }
      else
        format.html { render :edit }
      end
      else
        flash[:alert] = '身份证号已占用'
        format.html { render :edit }
      end
    end
  end

  def destroy
    @camp_student.destroy
    respond_to do |format|
      format.html { redirect_to referer_or(admin_project_season_apply_camp_students_path(apply_camp_id: @apply_camp.id)), notice: '删除成功。' }
    end
  end

  def check
    respond_to do |format|
      state = camp_student_params[:state]
      @camp_student.state = state
      if @camp_student.save
        @camp_student.audits.create(state: state, user_id: current_user.id, comment: camp_student_params[:approve_remark])
        format.html { redirect_to referer_or(admin_project_season_apply_camp_students_path(apply_camp_id: @apply_camp.id)), notice: '审核成功' }
      else
        format.html { render :show }
      end
    end
  end

  private
  def set_apply_camp
    @apply_camp = ProjectSeasonApplyCamp.find(params[:apply_camp_id])
  end

  def set_camp_student
    @camp_student = ProjectSeasonApplyCampMember.find(params[:id])
  end

  def camp_student_params
    params.require(:project_season_apply_camp_member).permit!
  end

  def check_auth
    auth_operate_project(Project.camp_project)
  end

end
