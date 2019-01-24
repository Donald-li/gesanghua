class Platform::School::Apply::ChildrenController < Platform::School::BaseController
  before_action :set_apply
  before_action :set_child, only: [:edit, :update, :destroy, :visit_list, :visit_form, :visit_update, :visit_create]

  def index
    scope = @apply.children.where(approve_state: params[:state]).sorted
    @children = scope.page(params[:page]).per(10)
  end

  def child_list
    @search = @apply.children.draft.ransack(params[:q])
    scope = @search.result
    @children = scope.sorted
  end

  def new
    @child = ProjectSeasonApplyChild.new
  end

  def create
    @child = ProjectSeasonApplyChild.new(child_params.merge(project: Project.pair_project, season: @apply.season, apply: @apply, school: @apply.school, province: @apply.province, city: @apply.city, district: @apply.district))
    unless params[:id_image_id].present?
      flash[:alert] = '请上传身份证或户口本'
      render :new and return
    end
    unless params[:room_image_id].present?
      flash[:alert] = '请上传客厅照片'
      render :new and return
    end
    unless params[:yard_image_id].present?
      flash[:alert] = '请上传园子照片'
      render :new and return
    end
    unless params[:apply_one_id].present?
      flash[:alert] = '请上传申请书1'
      render :new and return
    end
    if ProjectSeasonApplyChild.allow_apply?(@apply.school, child_params[:id_card])
      if @child.save
        @child.attach_avatar(params[:avatar_id])
        @child.attach_id_image(params[:id_image_id])
        @child.attach_poverty(params[:poverty_id])
        @child.attach_room_image(params[:room_image_id])
        @child.attach_yard_image(params[:yard_image_id])
        @child.attach_apply_one(params[:apply_one_id])
        @child.attach_apply_two(params[:apply_two_id])
        redirect_to child_list_platform_school_apply_pair_children_path, notice: '新增成功。'
      else
        flash[:alert] = '保存失败'
        render :new
      end
    else
      flash[:alert] = '身份证号已占用'
      render :new
    end
  end

  def edit
  end

  def excel_output
    logger.info @apply.inspect
    logger.info @apply.school.inspect
    send_data(ExcelOutput.export_pair_students(params[:child_ids].split(',')),
              filename: "#{@apply.school.try(:name)}结对学生名单#{Date.today.to_s}.xlsx".encode('GBK'),
              type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
              disposition: 'attachment'
    )
  end

  def update
    respond_to do |format|
      if ProjectSeasonApplyChild.allow_apply?(@apply.school, child_params[:id_card], @child)
        if @child.update(child_params)
          @child.attach_avatar(params[:avatar_id])
          @child.attach_id_image(params[:id_image_id])
          @child.attach_poverty(params[:poverty_id])
          @child.attach_room_image(params[:room_image_id])
          @child.attach_yard_image(params[:yard_image_id])
          @child.attach_apply_one(params[:apply_one_id])
          @child.attach_apply_two(params[:apply_two_id])
          format.html {redirect_to child_list_platform_school_apply_pair_children_path, notice: '修改成功。'}
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
    @child.destroy
    redirect_to child_list_platform_school_apply_pair_children_path, notice: '删除成功。'
  end

  def visit_list
    @visits = @child.visits.sorted
  end

  def visit_form
    @visit = params[:visit_id].present? ? Visit.find(params[:visit_id]) : Visit.new
  end

  def visit_create
    @visit = Visit.new(visit_params.merge(user: current_user, apply_child: @child))
    if @visit.save
      @visit.members = FamilyMember.find(visit_params[:member_ids])
      @visit.attach_images(params[:image_ids])
      redirect_to visit_list_platform_school_apply_pair_child_path(@apply, @child), notice: '修改成功。'
    else
      flash[:alert] = '修改失败'
      format.html {render :visit_form}
    end
  end

  def visit_update
    @visit = Visit.find(params[:visit_id])
    if @visit.update(visit_params)
      @visit.members = FamilyMember.find(visit_params[:member_ids])
      @visit.attach_images(params[:image_ids])
      redirect_to visit_list_platform_school_apply_pair_child_path(@apply, @child), notice: '修改成功。'
    else
      flash[:alert] = '修改失败'
      format.html {render :visit_form}
    end
  end

  private

  def set_apply
    @apply = ProjectSeasonApply.find(params[:pair_id])
  end

  def set_child
    @child = ProjectSeasonApplyChild.find(params[:id])
  end

  def child_params
    params.require(:project_season_apply_child).permit!
  end

  def visit_params
    params.require(:visit).permit!
  end
end
