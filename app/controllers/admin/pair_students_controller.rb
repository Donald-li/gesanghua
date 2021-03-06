class Admin::PairStudentsController < Admin::BaseController
  before_action :set_project_apply
  before_action :set_apply_child, only: [:show, :edit, :update, :destroy, :check, :info]

  def index
    @search = @project_apply.children.where(school: @project_apply.school).check_list.includes(:gsh_child_grants).sorted.ransack(params[:q])
    scope = @search.result
    @children = scope.page(params[:page])
    respond_to do |format|
      format.html { @children = scope.page(params[:page]) }
      format.xlsx {
        @children = scope.sorted
        OperateLog.create_export_excel(current_user,  @project_apply.school.try(:name) + '结对学生名单')
        response.headers['Content-Disposition'] = 'attachment; filename=' + @project_apply.school.try(:name) + '结对学生名单' + Date.today.to_s + '.xlsx'
      }
    end
  end

  def show
    store_referer
  end

  def info
  end

  def new
    @apply_child = @project_apply.children.build
  end

  def edit
    @audit = @apply_child.audits.last || @apply_child.audits.create
    @new_audit = @apply_child.audits.build(state: 2)
  end

  def create
    respond_to do |format|
      @apply_child = @project_apply.children.build(apply_child_params.merge(province: @project_apply.province, city: @project_apply.city, district: @project_apply.district))
      if ProjectSeasonApplyChild.allow_apply?(@project_apply.school, apply_child_params[:id_card])
        @apply_child.audits.build
        if apply_child_params[:information].empty?
          flash[:alert] = '请填写孩子介绍'
          format.html {render :new and return}
        end
        if @apply_child.approve_pass
          @apply_child.attach_avatar(params[:avatar_id])
          @apply_child.attach_id_image(params[:id_image_id])
          @apply_child.attach_poverty(params[:poverty_id])
          @apply_child.attach_room_image(params[:room_image_id])
          @apply_child.attach_yard_image(params[:yard_image_id])
          @apply_child.attach_apply_one(params[:apply_one_id])
          @apply_child.attach_apply_two(params[:apply_two_id])
          @apply_child.attach_other(params[:other_ids])
          format.html {redirect_to referer_or(admin_pair_apply_pair_students_path(@project_apply)), notice: '新增成功。'}
        else
          format.html {render :new}
        end
      else
        flash[:alert] = '身份证号已占用'
        format.html {render :new}
      end
    end
  end

  def update
    respond_to do |format|
      if ProjectSeasonApplyChild.allow_apply?(@project_apply.school, apply_child_params[:id_card], @apply_child)
        if apply_child_params[:information].empty?
          flash[:alert] = '请填写孩子介绍'
          format.html {render :edit and return}
        end
        if @apply_child.update(apply_child_params)
          @apply_child.attach_avatar(params[:avatar_id])
          @apply_child.attach_id_image(params[:id_image_id])
          @apply_child.attach_poverty(params[:poverty_id])
          @apply_child.attach_room_image(params[:room_image_id])
          @apply_child.attach_yard_image(params[:yard_image_id])
          @apply_child.attach_apply_one(params[:apply_one_id])
          @apply_child.attach_apply_two(params[:apply_two_id])
          @apply_child.attach_other(params[:other_ids])
          format.html {redirect_to referer_or(admin_pair_apply_pair_students_path(@project_apply)), notice: '修改成功。'}
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

    respond_to do |format|
      if @apply_child.destroy
      format.html {redirect_to referer_or(admin_pair_apply_pair_students_path(@project_apply)), notice: '删除成功。'}
      else
        format.html {redirect_to referer_or(admin_pair_apply_pair_students_path(@project_apply)), alert: '删除失败。'}
      end
    end
  end

  def check
    respond_to do |format|
      approve_state = apply_child_params[:approve_state]
      @apply_child.approve_state = approve_state
      if @apply_child.save
        @apply_child.audits.create(state: approve_state, user_id: current_user.id, comment: apply_child_params[:approve_remark])
        if @apply_child.pass?
          @apply_child.approve_pass
        end

        # 审核结果通知
        notice = Notification.create(
          kind: @apply_child.pass? ? 'approve_pass' : 'approve_reject',
          owner: @apply_child,
          user_id: @apply_child.apply.applicant_id,
          title: @apply_child.pass? ? '#审核通过# 结对助学学生审核结果' : '#审核未通过# 结对助学学生审核结果',
          content: @apply_child.pass? ? "#{@apply_child.name}同学审核通过" : "#{@apply_child.name}同学审核未通过",
          url: "#{Settings.m_root_url}/cooperation/school/main"
        )

        format.html {redirect_to referer_or(admin_pair_apply_pair_students_path(@project_apply)), notice: '审核成功'}
      else
        format.html {render :show}
      end
    end
  end


  def new_audit
    @apply_child = ProjectSeasonApplyChild.find(params[:id])
    @audit = @apply_child.audits.build
  end

  def create_audit
    @apply_child = ProjectSeasonApplyChild.find(params[:audit][:pair_student_id])
    @new_audit = @apply_child.audits.build(state: params[:audit][:state], comment: params[:audit][:comment], user_id: current_user.id)
    respond_to do |format|
      if @new_audit.save
        # if @audit.pass? && @apply_child.gsh_child.blank?
        #   @apply_child.build_gsh_child(name: @apply_child.name, phone: @apply_child.phone, id_card: @apply_child.id_card, province: @apply_child.province, city: @apply_child.city, district: @apply_child.district)
        # end
        #
        params[:audit][:state] == 'pass' ? @apply_child.approve_pass : @apply_child.approve_reject
        format.js
      else
        format.html {render :new_audit}
      end
    end
  end

  def edit_audti
    @apply_child = ProjectSeasonApplyChild.find(params[:id])
    @audit = @apply_child.audits.last
  end

  def update_audit
    @apply_child = ProjectSeasonApplyChild.find(params[:audit][:pair_student_id])
    @audit = @apply_child.audits.last
    respond_to do |format|
      if @audit.update(state: params[:audit][:state], comment: params[:audit][:comment], user_id: current_user.id)
        params[:audit][:state] == 'pass' ? @apply_child.approve_pass : @apply_child.approve_reject
        format.js
      else
        format.html {render :edit}
      end
    end
  end

  def excel_upload
  end

  def excel_import
    respond_to do |format|
      result = ProjectSeasonApplyChild.read_excel(params[:apply_child_excel_id], @project_apply)
      if result[:status]
        format.html {redirect_to referer_or(admin_pair_apply_pair_students_path(@project_apply)), notice: '导入成功'}
      else
        flash.now[:alert] = result[:message]
        format.html {render :excel_upload}
      end
    end
  end

  private
  def set_project_apply
    @project_apply = ProjectSeasonApply.find(params[:pair_apply_id])
  end

  def apply_child_params
    params.require(:project_season_apply_child).permit!
  end

  def set_apply_child
    @apply_child = ProjectSeasonApplyChild.find(params[:id])
  end

end
