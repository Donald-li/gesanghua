class Platform::School::Apply::MembersController < Platform::School::BaseController
  before_action :check_manage_limit
  before_action :set_apply_camp
  before_action :set_member, only: [:edit, :update, :destroy]

  def index
    scope = @apply_camp.camp_members.where(state: params[:state]).sorted
    @members = scope.page(params[:page]).per(10)
  end

  def member_list
    @search = @apply_camp.camp_members.ransack(params[:q])
    scope = @search.result
    @members = scope.sorted
  end

  def new
    @member = ProjectSeasonApplyCampMember.new
  end

  def create
    @member = ProjectSeasonApplyCampMember.new(member_params.merge(apply_camp: @apply_camp, apply: @apply_camp.apply, school: @apply_camp.school, camp: @apply_camp.camp))
    respond_to do |format|
      if ProjectSeasonApplyCampMember.allow_apply?(@apply_camp, member_params[:id_card])
      if @member.save
        @member.attach_image(params[:image_id])
        @member.count_age
        format.html { redirect_to member_list_platform_school_apply_camp_members_path, notice: '新增成功。' }
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
      if ProjectSeasonApplyCampMember.allow_apply?(@apply_camp, member_params[:id_card], @member)
      if @member.update(member_params)
        @member.attach_image(params[:image_id])
        @member.count_age
        format.html { redirect_to member_list_platform_school_apply_camp_members_path, notice: '新增成功。' }
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
    @member.destroy
    respond_to do |format|
        format.html { redirect_to member_list_platform_school_apply_camp_members_path, notice: '删除成功。' }
    end
  end

  private
  def check_manage_limit
    redirect_to root_path unless current_teacher.manage_projects.where(alias: 'camp').exists?
  end

  def set_apply_camp
    @apply_camp = ProjectSeasonApplyCamp.find(params[:camp_id])
  end

  def set_member
    @member = ProjectSeasonApplyCampMember.find(params[:id])
  end

  def member_params
    params.require(:project_season_apply_camp_member).permit!
  end
end
