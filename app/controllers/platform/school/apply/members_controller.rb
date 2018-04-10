class Platform::School::Apply::MembersController < Platform::School::BaseController
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
      if @member.save
        @member.attach_image(params[:image_id])
        @member.count_age
        format.html { redirect_to member_list_platform_school_apply_camp_members_path, notice: '新增成功。' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update

  end

  def destroy
  end

  private
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
