class Admin::ReadExceptionRecordsController < Admin::BaseController
  before_action :set_exception_record, only: [:edit, :update]
  before_action :set_project
  before_action :set_project_apply

  def index
    # @exception_records = @apply.exception_records
    @exception_records = ExceptionRecord.where(owner: @apply)
    set_search_end_of_day(:created_at_lteq)
    @search = @exception_records.ransack(params[:q])
    scope = @search.result
    @exception_records = scope.sorted.page(params[:page])
  end

  def new
    @exception_record = ExceptionRecord.new
  end

  def create
    @exception_record = ExceptionRecord.new(exception_record_params.merge(owner: @apply))
    respond_to do |format|
      if @exception_record.save
        # 异常发通知
        owner = @exception_record.owner
        title = '#逾期提醒#' + @exception_record.title
        content = @exception_record.content
        users = CountyUser.where(district: owner.try(:school).try(:district))
        if users.present?
          users.each do |user|
            notice = Notification.create(
              kind: 'exception_record',
              owner: owner,
              user_id: user.id,
              title: title,
              content: content
            )
          end
        end
        format.html {redirect_to admin_read_projects_path, notice: '新增成功。'}
      else
        flash[:notice] = '新增失败，请检查表单'
        format.html {render :new}
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @exception_record.update(exception_record_params.merge(owner: @apply))
        format.html {redirect_to admin_read_projects_path, notice: '修改成功。'}
      else
        flash[:notice] = '修改失败，请检查表单'
        format.html {render :new}
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_exception_record
    @exception_record = ExceptionRecord.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def exception_record_params
    params.require(:exception_record).permit!
  end

  def set_project
    @project = Project.read_project
    auth_operate_project(@project)
  end

  def set_project_apply
    @apply = ProjectSeasonApply.find(params[:read_project_id])
  end
end
