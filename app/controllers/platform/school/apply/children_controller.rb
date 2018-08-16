class Platform::School::Apply::ChildrenController < Platform::School::BaseController
  before_action :check_manage_limit
  before_action :set_apply
  before_action :set_child, only: [:edit, :update, :destroy]

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
    respond_to do |format|
      if ProjectSeasonApplyChild.allow_apply?(@apply.school, child_params[:id_card])
        if @child.save
          @child.attach_avatar(params[:avatar_id])
          @child.attach_id_image(params[:id_image_id])
          @child.attach_poverty(params[:poverty_id])
          @child.attach_room_image(params[:room_image_id])
          @child.attach_yard_image(params[:yard_image_id])
          @child.attach_apply_one(params[:apply_one_id])
          @child.attach_apply_two(params[:apply_two_id])
          format.html {redirect_to child_list_platform_school_apply_pair_children_path, notice: '新增成功。'}
        else
          format.html {render :new}
        end
      else
        flash[:alert] = '身份证号已占用'
        format.html {render :new}
      end
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

  private
  def check_manage_limit
    redirect_to root_path unless current_teacher.manage_projects.where(alias: 'pair').exists?
  end

  def set_apply
    @apply = ProjectSeasonApply.find(params[:pair_id])
  end

  def set_child
    @child = ProjectSeasonApplyChild.find(params[:id])
  end

  def child_params
    params.require(:project_season_apply_child).permit!
  end
end
