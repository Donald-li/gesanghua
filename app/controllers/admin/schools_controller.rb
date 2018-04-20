class Admin::SchoolsController < Admin::BaseController
  before_action :auth_manage_operation
  before_action :set_school, only: [:show, :edit, :update, :destroy, :switch]

  def index
    respond_to do |format|
      format.html do # HTML页面
        @search = School.sorted.pass.ransack(params[:q])
        scope = @search.result
        @schools = scope.page(params[:page])
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
        format.html { redirect_to referer_or(admin_schools_url), notice: '学校已增加。' }
      else
        format.html { render :new }
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
        format.html { redirect_to referer_or(admin_schools_url), notice: '学校信息已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @school.destroy
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
    respond_to do |format|
      format.html { redirect_to referer_or(admin_schools_url), notice: '学校已删除。' }
    end
  end

  def switch
    @school.enable? ? @school.disable! : @school.enable!
    redirect_to admin_schools_url, notice:  @school.enable? ? '学校已启用' : '学校已禁用'
  end

  private
  def set_school
    @school = School.find(params[:id])
  end

  def school_params
    params.require(:school).permit!
  end
end
