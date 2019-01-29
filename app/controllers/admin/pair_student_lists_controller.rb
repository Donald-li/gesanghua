class Admin::PairStudentListsController < Admin::BaseController
  before_action :set_pair_student_list, only: [:show, :edit, :update, :destroy, :switch, :remarks, :turn_over, :share, :qrcode_download, :appoint, :appoint_donor]
  before_action :store_referer, only: [:turn_over]

  def index
    params[:q] ||= {}
    @search = ProjectSeasonApplyChild.includes(:project, :gsh_child_grants).pass.sorted.ransack(params[:q])
    scope = @search.result
    if donor_state = params[:donor_state_eq]
      scope = scope.where('project_season_apply_children.done_semester_count = 0') if donor_state == 'raising'
      scope = scope.where('project_season_apply_children.done_semester_count = project_season_apply_children.semester_count') if donor_state == 'done'
      scope = scope.where('project_season_apply_children.done_semester_count between 1 and project_season_apply_children.semester_count - 1') if donor_state == 'part_done'
    end
    respond_to do |format|
      format.html {@pair_student_lists = scope.page(params[:page])}
      format.xlsx {
        @pair_student_lists = scope.sorted
        OperateLog.create_export_excel(current_user, '捐助管理学生名单')
        response.headers['Content-Disposition'] = 'attachment; filename="捐助管理学生名单"' + Date.today.to_s + '.xlsx'
      }
    end
  end

  def show
    @feedbacks = @pair_student_list.continual_feedbacks.score.sorted
  end

  def new
    @pair_student_list = ProjectSeasonApplyChild.new
  end

  def edit
  end

  def update
    @project_apply = @pair_student_list.apply
    respond_to do |format|
      if ProjectSeasonApplyChild.allow_apply?(@project_apply.school, pair_student_list_params[:id_card], @pair_student_list)
        if pair_student_list_params[:information].empty?
          flash[:alert] = '请填写孩子介绍'
          format.html {render :edit and return}
        end
        if @pair_student_list.update(pair_student_list_params)
          @pair_student_list.attach_avatar(params[:avatar_id])
          @pair_student_list.attach_id_image(params[:id_image_id])
          @pair_student_list.attach_poverty(params[:poverty_id])
          @pair_student_list.attach_room_image(params[:room_image_id])
          @pair_student_list.attach_yard_image(params[:yard_image_id])
          @pair_student_list.attach_apply_one(params[:apply_one_id])
          @pair_student_list.attach_apply_two(params[:apply_two_id])
          format.html {redirect_to referer_or(admin_pair_student_lists_path), notice: '修改成功。'}
        else
          format.html {render :edit}
        end
      else
        flash[:alert] = '身份证号已占用'
        format.html {render :edit}
      end
    end
  end

  def destroy
    @pair_student_list.destroy
    respond_to do |format|
      format.html {redirect_to referer_or(admin_pair_student_lists_path), notice: '删除成功。'}
    end
  end

  def switch
    @pair_student_list.show? ? @pair_student_list.hidden! : @pair_student_list.show!
    redirect_to referer_or(admin_pair_student_lists_path), notice: @pair_student_list.show? ? '已开启筹款' : '已关闭筹款'
  end

  def remarks
    @apply_child = ProjectSeasonApplyChild.find(params[:id])
    @search = @apply_child.remarks.sorted.ransack(params[:q])
    scope = @search.result
    @remarks = scope.page(params[:page])
    store_referer
  end

  def turn_over
    @pair_student_list.inside? ? @pair_student_list.outside! : @pair_student_list.inside!
    redirect_to referer_or(admin_pair_student_lists_path), notice: @pair_student_list.inside? ? '标记内部认捐成功' : '标记平台可见成功'
  end

  def share
    @pair_student_list.generate_qrcode
    store_referer
  end

  def qrcode_download
    send_file(File.join(Rails.root, 'public', @pair_student_list.qrcode_url), filename: "#{@pair_student_list.gsh_child.gsh_no}-分享二维码")
  end

  def appoint
    store_referer
  end

  def appoint_donor
    @pair_student_list.priority_id = params[:project_season_apply_child][:priority_id]
    if @pair_student_list.save
      notice = Notification.create(
          kind: 'appoint_donor',
          owner: @pair_student_list,
          user_id: @pair_student_list.priority_id,
          title: "#结对通知# 系统为您结对啦",
          content: "系统将您指定为孩子#{@pair_student_list.name}的捐助人，快去捐助吧",
          url: "#{Settings.m_root_url}/pair/#{@pair_student_list.id}"
      )
      redirect_to referer_or(admin_pair_student_lists_path), notice: @pair_student_list.priority_id.present? ? '指定捐助人成功，并发送微信通知' : '未设置捐助人'
    else
      redirect_to referer_or(admin_pair_student_lists_path), notice: '指定捐助人失败'
    end
  end

  def batch_manage
    store_referer
  end

  def grade_add_one
    @pair_student_lists = ProjectSeasonApplyChild.can_batch_update.where.not(grade: ['three', 'four', 'five', 'six']).sorted
    num = 0
    @total = @pair_student_lists.count
    @pair_student_lists.transaction do
      # @pair_student_lists.each do |student|
      #   if student.one?
      #     if student.update(grade: 'two')
      #       num += 1
      #     end
      #   elsif student.two?
      #     if student.update(grade: 'three')
      #       num +=1
      #     end
      #   end
      # end
      @one_list = @pair_student_lists.one
      @one_count = @one_list.count
      @two_list = @pair_student_lists.two
      @two_count = @two_list.count
      if @two_list.update_all(grade: 'three')
        num += @two_count
      end
      if @one_list.update_all(grade: 'two')
        num += @one_count
      end
    end
    respond_to do |format|
      logger.info "========++++++++==待操作人数：#{@total}========+++++++++"
      logger.info "========++++++++==实际操作人数：#{num}一年级：#{@one_count}二年级：#{@two_count}========+++++++++"
      if num == @total
        format.html {redirect_to batch_manage_admin_pair_student_lists_path, notice: '操作成功。'}
      else
        flash[:alert] = '操作失败'
        format.html {render :batch_manage}
      end
    end
  end

  def grade_minus_one
    @pair_student_lists = ProjectSeasonApplyChild.can_batch_update.where.not(grade: ['one', 'four', 'five', 'six']).sorted
    num = 0
    @total = @pair_student_lists.count
    @pair_student_lists.transaction do
      # @pair_student_lists.each do |student|
      #   if student.two?
      #     if student.update(grade: 'one')
      #       num += 1
      #     end
      #   elsif student.three?
      #     if student.update(grade: 'two')
      #       num +=1
      #     end
      #   end
      # end
      @two_list = @pair_student_lists.two
      @two_count = @two_list.count
      @three_list = @pair_student_lists.three
      @three_count = @three_list.count
      if @two_list.update_all(grade: 'one')
        num += @two_count
      end
      if @three_list.update_all(grade: 'two')
        num += @three_count
      end
    end
    respond_to do |format|
      logger.info "========++++++++==待操作人数：#{@total}========+++++++++"
      logger.info "========++++++++==实际操作人数：#{num}二年级：#{@two_count}三年级：#{@three_count}========+++++++++"
      if num == @total
        format.html {redirect_to batch_manage_admin_pair_student_lists_path, notice: '操作成功。'}
      else
        flash[:alert] = '操作失败'
        format.html {render :batch_manage}
      end
    end
  end

  def push_notice
    ProjectSeasonApplyChild.batch_push_notice
    redirect_to batch_manage_admin_pair_student_lists_path, notice: '推送成功。'
  end

  def update_priority
    ProjectSeasonApplyChild.update_priority_users
    redirect_to batch_manage_admin_pair_student_lists_path, notice: '更新成功。'
  end

  def batch_donate
    params[:q] ||= {}
    ids = ProjectSeasonApplyChild.where(project: Project.pair_project).joins(:semesters)
              .where(gsh_child_grants: {donate_state: :pending})
              .select("distinct project_season_apply_children.id").pluck(:id).uniq
    @children = ProjectSeasonApplyChild.where(id: ids).includes(:gsh_child).pass.sorted
    @search = @children.ransack(params[:q])
    scope = @search.result
    if donor_state = params[:donor_state_eq]
      scope = scope.where('project_season_apply_children.done_semester_count = 0') if donor_state == 'raising'
      scope = scope.where('project_season_apply_children.done_semester_count = project_season_apply_children.semester_count') if donor_state == 'done'
      scope = scope.where('project_season_apply_children.done_semester_count between 1 and project_season_apply_children.semester_count - 1') if donor_state == 'part_done'
    end
    @pair_student_lists = scope
  end

  def batch_grant
    unless params[:child_ids].present?
      redirect_to batch_donate_admin_pair_student_lists_path, notice: "请勾选孩子" and return
    end
    success = 0
    fail = 0
    message_list = []
    params[:child_ids].split(',').each do |child_id|
      child = ProjectSeasonApplyChild.find_by(id: child_id)
      grant = child.semesters.pending.sorted.last
      if grant.present?
        result, message = DonateRecord.platform_donate(child, grant.amount, params.permit!.merge(current_user: current_user))
        if result
          success += 1
        else
          fail += 1
          message_list.push(message)
        end
      end
    end
    if fail == 0
      redirect_to batch_donate_admin_pair_student_lists_path, notice: '配捐成功。'
    else
      redirect_to batch_donate_admin_pair_student_lists_path, notice: "配捐成功#{success}个，失败#{fail}个,原因：#{message_list.join(',')}"
    end

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pair_student_list
    @pair_student_list = ProjectSeasonApplyChild.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pair_student_list_params
    params.require(:project_season_apply_child).permit!
  end

  def store_referer
    session[:admin_referer] = request.referer if request.referer.present? && session[:skip_referer].blank?
    session.delete(:skip_referer) if session[:skip_referer]
  end

end
