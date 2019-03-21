class Admin::PairGrantsController < Admin::BaseController
  before_action :set_grant, except: [:index, :create_feedback, :excel_output]

  def index
    set_search_end_of_day(:published_at_lteq)
    @search = GshChildGrant.where.not(donate_state: 'close').ransack(params[:q])
    scope = @search.result
    if feedback_state = params[:feedback_state_eq]
      scope = scope.where('feedback_count = 0') if feedback_state == 'to_feedback'
      scope = scope.where('feedback_count > 0') if feedback_state == 'feedbacked'
    end
    scope = scope.includes(:school, :gsh_child, :apply)

    @accrue_grants = scope.where.not(donate_state: 'close').where(state: 'granted', management_fee_state: 'unaccrue')
    @accrue_count = scope.where.not(donate_state: 'close').where(state: 'granted', management_fee_state: 'unaccrue').count
    @accrue_amount = scope.where.not(donate_state: 'close').where(state: 'granted', management_fee_state: 'unaccrue').sum(:amount)
    @rate = Project.pair_project.management_rate
    @accrue_total = format('%.2f', @accrue_amount * @rate / (100 + @rate))

    respond_to do |format|
      format.html {@grants = scope.reverse_sorted.page(params[:page])}
      format.xlsx {
        @grants = scope.sorted.all
        OperateLog.create_export_excel(current_user, '结对发放列表')
        response.headers['Content-Disposition'] = 'attachment; filename= "结对发放列表" ' + Date.today.to_s + '.xlsx'
      }
    end
  end

  def edit
  end

  # 计提管理费
  def accrue
    @item = @grant
    @project = Project.pair_project
    @management_fee = ManagementFee.new
    render template: '/admin/management_fees/accrue'
  end

  def update
    respond_to do |format|
      if @grant.update(grant_params)
        @grant.attach_images(params[:image_ids])
        @grant.granted_at = Time.now
        @grant.granted!
        notice = Notification.create(
            kind: 'child_granted',
            owner: @grant,
            user_id: @grant.user_id,
            title: "#发放通知# 你的捐款发放啦",
            content: "你捐助的 #{@grant.apply_child.name} 助学款已经发放。发放时间: #{ @grant.granted_at.strftime('%Y-%m-%d') } 发放人: #{ grant_params[:grant_person] }",
            url: "#{Settings.m_root_url}/pair/#{@grant.apply_child.try(:id)}"
        )
        format.html {redirect_to referer_or(admin_pair_grants_path), notice: '操作成功。'}
      else
        format.html {render :edit}
      end
    end
  end

  def edit_delay
    store_referer
  end

  def edit_cancel
    store_referer
  end

  def edit_feedback
    store_referer
  end

  def update_delay
    respond_to do |format|
      if @grant.update(grant_params)
        @grant.suspend!
        format.html {redirect_to referer_or(admin_pair_grants_path), notice: '操作成功。'}
      else
        format.html {render :edit_delay}
      end
    end
  end

  def cancel_delay
    respond_to do |format|
      if @grant.waiting!
        format.html {redirect_to referer_or(admin_pair_grants_path), notice: '操作成功。'}
      else
        format.html {redirect_to referer_or(admin_pair_grants_path), alert: '操作失败。'}
      end
    end
  end

  def update_cancel
    respond_to do |format|
      if @grant.update(grant_params.merge(operator_id: current_user.id))
        if @grant.do_refund!(current_user)
          format.html {redirect_to referer_or(admin_pair_grants_path), notice: '操作成功。'}
        else
          format.html {redirect_to referer_or(admin_pair_grants_path), alert: '无法退款。'}
        end
      else
        format.html {render :edit_cancel}
      end
    end
  end

  def update_feedback
    respond_to do |format|
      if @grant.update(grant_params)
        @grant.attach_images(params[:image_ids])
        format.html {redirect_to referer_or(admin_pair_grants_path), notice: '发放反馈已修改。'}
      else
        format.html {render :edit_feedback}
      end
    end
  end

  def share
  end

  def qrcode_download
    send_file(File.join(Rails.root, 'public', @grant.apply_child.try(:qrcode_url)), filename: "#{@grant.apply_child.try(:gsh_child).try(:gsh_no)}-分享二维码")
  end

  def switch
    store_referer
    @grant.state = params[:state]
    if @grant.save
      redirect_to referer_or(admin_pair_grants_path), notice: '标记成功。'
    else
      redirect_to referer_or(admin_pair_grants_path), notice: '标记失败。'
    end
  end

  private
  def set_grant
    @grant = GshChildGrant.find(params[:id])
  end

  def grant_params
    params.require(:gsh_child_grant).permit!
  end


end
