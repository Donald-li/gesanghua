class Platform::School::Apply::FamilyMembersController < Platform::School::BaseController
  before_action :set_apply, :set_child
  before_action :set_member, only: [:edit, :update]

  def index
  end

  def new
    @member = FamilyMember.new
  end

  def create
    @member = FamilyMember.new(member_params)
  end

  def edit
  end

  def update
    @result = @member.update(member_params)
  end

  private

  def set_apply
    @apply = ProjectSeasonApply.find(params[:pair_id])
  end

  def set_child
    @child = ProjectSeasonApplyChild.find(params[:child_id])
  end

  def set_member
    @member = FamilyMember.find(params[:id])
  end

  def member_params
    params.require(:family_member).permit!
  end

end
