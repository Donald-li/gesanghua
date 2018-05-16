class Admin::PairGrantsController < Admin::BaseController
  before_action :check_auth
  before_action :set_grant, except: [:index, :create_feedback, :excel_output]

  def index
    set_search_end_of_day(:published_at_lteq)
    @search = GshChildGrant.joins(:gsh_child).where.not(donate_state: 'close').sorted.ransack(params[:q])
    scope = @search.result
    scope = scope.includes(:school, :gsh_child)

    respond_to do |format|
      format.html {@grants = scope.page(params[:page])}
      format.xlsx {
        @grants = scope.sorted.all
        response.headers['Content-Disposition'] = 'attachment; filename= "结对发放列表" ' + Date.today.to_s + '.xlsx'
      }
    end

  end

  #
  # def excel_output
  #   ExcelOutput.pair_grants_output
  #   file_path = Rails.root.join("public/files/一对一发放" + DateTime.now.strftime("%Y-%m-%d-%s") + ".xlsx")
  #   file_name = "一对一捐助发放.xlsx"
  #   send_file(file_path, filename: file_name)
  # end

  def edit
  end

  # 计提管理费
  def accrue
    @item = @grant
    @fund = Project.pair_project.appoint_fund
    @management_fee = ManagementFee.new
    render template: '/admin/management_fees/accrue'
  end

  def update
    respond_to do |format|
      if @grant.update(grant_params)
        @grant.attach_images(params[:image_ids])
        @grant.granted!
        format.html {redirect_to admin_pair_grants_path, notice: '操作成功。'}
      else
        format.html {render :edit}
      end
    end
  end

  def edit_delay
  end

  def edit_cancel
  end

  def edit_feedback
  end

  def update_delay
    respond_to do |format|
      if @grant.update(grant_params)
        @grant.suspend!
        format.html {redirect_to admin_pair_grants_path, notice: '操作成功。'}
      else
        format.html {render :edit_delay}
      end
    end
  end

  def update_cancel
    respond_to do |format|
      if @grant.update(grant_params.merge(operator_id: current_user.id))
        @grant.do_refund!
        format.html {redirect_to admin_pair_grants_path, notice: '操作成功。'}
      else
        format.html {render :edit_cancel}
      end
    end
  end

  def update_feedback
    respond_to do |format|
      if @grant.update(grant_params)
        @grant.attach_images(params[:image_ids])
        format.html {redirect_to admin_pair_grants_path, notice: '发放反馈已修改。'}
      else
        format.html {render :edit_feedback}
      end
    end
  end

  private
  def set_grant
    @grant = GshChildGrant.find(params[:id])
  end

  def grant_params
    params.require(:gsh_child_grant).permit!
  end

  def check_auth
    auth_operate_project(Project.pair_project)
  end

end
