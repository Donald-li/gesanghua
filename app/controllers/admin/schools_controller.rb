class Admin::SchoolsController < Admin::BaseController

  before_action :set_school, only: [:show, :edit, :update, :destroy, :switch]

  def index
    respond_to do |format|
      format.html do # HTML页面
        @search = School.sorted.ransack(params[:q])
        scope = @search.result
        @schools = scope.page(params[:page])
      end
    end
  end

  def show
  end

  def excel_output
    ExcelOutput.school_output
    file_path = Rails.root.join("public/files/学校" + DateTime.now.strftime("%Y-%m-%d-%s") + ".xlsx")
    file_name = "学校信息.xlsx"
    send_file(file_path, filename: file_name)
  end

  def new
    @school=School.new
  end

  def create
    @school = School.new(school_params)
    @school.approve_state = 'pass'
    @user = @school.user
    Teacher.find_or_create_by(name: @school.contact_name, phone: @school.contact_phone, school: @school, user: @user, kind: 'headmaster')
    respond_to do |format|
      if @school.save
        @school.attach_logo(params[:logo_id])
        format.html { redirect_to referer_or(admin_schools_url), notice: '学校已增加。' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      @t = @school.user.teacher
      @user = User.find(school_params[:user_id])
      @school.user = @user
      @t.update(kind: 2) if @school.user_id_changed?
      Teacher.find_or_create_by(name: school_params[:contact_name], phone: school_params[:contact_phone], school: @school, user: @user, kind: 'headmaster')
      if @school.update(school_params)
        @school.attach_logo(params[:logo_id])
        format.html { redirect_to referer_or(admin_schools_url), notice: '学校信息已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @school.destroy
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
