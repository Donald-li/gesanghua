class Admin::StudentGrantsController < Admin::BaseController
  before_action :check_auth
  before_action :set_grant, only: [:show, :edit, :update, :destroy, :close]
  before_action :set_child_apply

  def index
    @search = @child_apply.gsh_child_grants.reverse_sorted.ransack(params[:q])
    scope = @search.result
    @grants = scope.page(params[:page])
  end

  def show
    store_referer
  end

  def new
    @grant = GshChildGrant.new
  end

  def create
    @grant = GshChildGrant.new(grant_params.merge(school_id: @child_apply.school_id, gsh_child: @child_apply.gsh_child, apply_child: @child_apply, project_season_apply_id: @child_apply.project_season_apply_id))

    respond_to do |format|
      if @grant.save
        format.html {redirect_to referer_or(admin_pair_student_list_student_grants_path(@child_apply)), notice: '新增成功。'}
      else
        format.html {render :new}
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @grant.update(grant_params)
        format.html {redirect_to referer_or(admin_pair_student_list_student_grants_path(@child_apply)), notice: '修改成功。'}
      else
        format.html {render :edit}
      end
    end
  end

  def close
    respond_to do |format|
      if @grant.close!
        format.html {redirect_to referer_or(admin_pair_student_list_student_grants_path(@child_apply)), notice: '关闭成功。'}
      else
        format.html {redirect_to referer_or(admin_pair_student_list_student_grants_path(@child_apply)), notice: '关闭失败。'}
      end
    end
  end

  def match
    store_referer
  end

  def match_donate
    amount = @child_apply.count_donate_amount_by_grant_number(params[:grant_number].to_i)
    respond_to do |format|
      if DonateRecord.platform_donate(@child_apply, amount, params.permit!.merge(current_user: current_user))
        format.html {redirect_to referer_or(admin_pair_student_list_student_grants_path(@child_apply)), notice: '配捐成功。'}
      else
        flash[:notice] = '配捐失败，请检查余额或表单'
        format.html {render :match}
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

  def check_auth
    auth_operate_project(Project.pair_project)
  end

end
