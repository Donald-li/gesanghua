class Admin::StudentGrantsController < Admin::BaseController
  before_action :set_grant, only: [:show, :destroy]
  before_action :set_child_apply

  def index
    @search = GshChildGrant.where(gsh_child_id: @child_apply.gsh_child_id).reverse_sorted.ransack(params[:q])
    scope = @search.result
    @grants = scope.page(params[:page])
  end

  def show
  end

  def new
    @grant = GshChildGrant.new
  end

  def create
    @grant = GshChildGrant.new(grant_params.merge(school_id: @child_apply.school_id, gsh_child: @child_apply.gsh_child, project_season_apply_id: @child_apply.project_season_apply_id))

    respond_to do |format|
      if @grant.save
        format.html {redirect_to admin_pair_student_list_student_grants_path(@child_apply), notice: '新增成功。'}
      else
        format.html {render :new}
      end
    end
  end

  def match
  end

  def match_donate
    respond_to do |format|
      if DonateRecord.platform_donate_child(params, @child_apply)
        format.html {redirect_to admin_pair_student_list_student_grants_path(@child_apply), notice: '配捐成功。'}
      else
        flash[:notice] = '检查余额或表单'
        format.html {render :edit}
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_grant
    @grant = GshChildGrant.find(params[:id])
  end

  def set_child_apply
    @child_apply = ProjectSeasonApplyChild.find(params[:pair_student_list_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def grant_params
    params.require(:gsh_child_grant).permit!
  end

  def donate_record_params
    params.require(:donate_record).permit!
  end

end
