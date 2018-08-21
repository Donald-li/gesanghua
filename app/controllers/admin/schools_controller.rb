class Admin::SchoolsController < Admin::BaseController
  before_action :auth_manage_operation
  before_action :set_school, only: [:show, :edit, :update, :destroy, :switch]

  def index
    @search = School.sorted.pass.ransack(params[:q])
    scope = @search.result
    respond_to do |format|
      format.html do # HTML页面
        @schools = scope.page(params[:page])
      end
      format.xlsx do # HTML页面
        @schools = scope.all
        OperateLog.create_export_excel(current_user, "学校列表")
        response.headers['Content-Disposition'] = 'attachment; filename= "学校列表" ' + Date.today.to_s + '.xlsx'
      end
    end
  end

  def show
  end

  def excel_output
    path = ExcelOutput.school_output
    send_file(path, filename: "学校信息.xlsx")
  end

  def new
    @school = School.new
  end

  def create
    @school = School.new(school_params)
    @school.approve_state = 'pass'
    if @school.user.present?
      @user = @school.user
      if !@user.has_role?(:headmaster)
        @user.add_role(:headmaster)
        @user.save
      end
      Teacher.find_or_create_by(name: @school.contact_name, phone: @school.contact_phone, school: @school, user: @user, kind: 'headmaster')
    end
    respond_to do |format|
      if @school.save
        format.html {redirect_to referer_or(admin_schools_url), notice: '学校已增加。'}
      else
        flash.now[:alert] = @school.errors.full_messages.first
        format.html {render :new}
      end
    end
  end

  def edit
  end

  def update
    if school_params[:user_id] != nil && school_params[:user_id] != ""
      @user = User.find(school_params[:user_id])
      @school.change_school_user(@user)
    else
      @school.change_school_user(nil)
    end
    respond_to do |format|
      if @school.update(school_params)
        format.html {redirect_to referer_or(admin_schools_url), notice: '学校信息已修改。'}
      else
        flash.now[:alert] = @school.errors.full_messages.first
        format.html {render :edit}
      end
    end
  end

  def destroy
    respond_to do |format|
      if @school.destroy
        if @school.user.present?
          @school.user.remove_role(:headmaster)
          @school.user.save
        end
        @school.teachers.each do |teacher|
          if teacher.user.present?
            teacher.user.remove_role(:teacher)
            teacher.user.save
          end
        end
        format.html {redirect_to referer_or(admin_schools_url), notice: '学校已删除。'}
      else
        format.html {redirect_to referer_or(admin_schools_url), notice: '请先删除该学校相关申请记录。'}
      end

    end
  end

  def switch
    @school.enable? ? @school.disable! : @school.enable!
    redirect_to referer_or(admin_schools_url), notice: @school.enable? ? '学校已启用' : '学校已禁用'
  end

  private
  def set_school
    @school = School.find(params[:id])
  end

  def school_params
    params.require(:school).permit!
  end
end
