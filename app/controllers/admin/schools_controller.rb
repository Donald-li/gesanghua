class Admin::SchoolsController < Admin::BaseController

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
    if @school.user.present?
      @user = @school.user
      @school.contact_name = @user.name
      @school.contact_phone = @user.phone
      @school.contact_id_card = @user.id_card
      if !@user.has_role?(:headmaster)
        @user.roles = @user.roles.push(:headmaster)
        @user.save
      end
      Teacher.find_or_create_by(name: @school.contact_name, phone: @school.contact_phone, school: @school, user: @user, kind: 'headmaster')
    end
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
    # if @school.user.present?
    #   @t = @school.user.teacher
    # end
    # if school_params[:user_id] != nil && school_params[:user_id] != ""
    #   @user = User.find(school_params[:user_id])
    #   @school.user = @user
    #   if @t.present?
    #     @t.update(kind: 2) if @school.user_id_changed?
    #   end
    #   Teacher.find_or_create_by(name: @user.name, phone: @user.phone, school: @school, user: @user, kind: 'headmaster')
    # else
    #   @school.user = nil
    #   if @t.present?
    #     @t.update(kind: 2)
    #   end
    # end
    if @school.user.present?
      @t = @school.user.teacher
      @t.update(kind: 2) if @t.present?
      @u = @school.user
      if @u.has_role?(:headmaster)
        @u.roles = @u.roles-[:headmaster]
        @u.save
      end
      if !@u.has_role?(:teacher)
        @u.roles = @u.roles.push(:teacher)
        @u.save
      end
      if school_params[:user_id] != nil && school_params[:user_id] != ""
        @user = User.find(school_params[:user_id])
        if @user.teacher.present?
          @user.teacher.update(kind: 1)
        else
          Teacher.create(name: @user.name, phone: @user.phone, school: @school, user: @user, kind: 'headmaster')
        end
        if !@user.has_role?(:headmaster)
          @user.roles = @user.roles.push(:headmaster)
          @user.save
        end
      else
        @school.user_id = nil
        if Teacher.find_by(name: school_params[:contact_name], phone: school_params[:contact_phone], school: @school).present?
          Teacher.find_by(name: school_params[:contact_name], phone: school_params[:contact_phone], school: @school).update(kind: 1)
        else
          Teacher.create(name: school_params[:contact_name], phone: school_params[:contact_phone], school: @school, kind: 'headmaster')
        end
        # Teacher.find_or_create_by(name: school_params[:contact_name], phone: school_params[:contact_phone], school: @school, kind: 'headmaster')
      end
    else
      if school_params[:user_id] != nil && school_params[:user_id] != ""
        @h = @school.teachers.find_by(kind: 1)
        @h.update(kind: 2) if @h.present?
        @user = User.find(school_params[:user_id])
        if @user.teacher.present?
          @user.teacher.update(kind: 1)
        else
          Teacher.create(name: @user.name, phone: @user.phone, school: @school, user: @user, kind: 'headmaster')
        end
        if !@user.has_role?(:headmaster)
          @user.roles = @user.roles.push(:headmaster)
          @user.save
        end
      else
        @school.user_id = nil
        if Teacher.find_by(name: school_params[:contact_name], phone: school_params[:contact_phone], school: @school).present?
          Teacher.find_by(name: school_params[:contact_name], phone: school_params[:contact_phone], school: @school).update(kind: 1)
        else
          Teacher.create(name: school_params[:contact_name], phone: school_params[:contact_phone], school: @school, kind: 'headmaster')
        end
      end
    end
    respond_to do |format|
      if @school.update(school_params)
        if @user.present?
          @school.contact_name = @user.name
          @school.contact_phone = @user.phone
          @school.contact_id_card = @user.id_card
          @school.save
        end
        @school.attach_logo(params[:logo_id])
        format.html { redirect_to referer_or(admin_schools_url), notice: '学校信息已修改。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @school.destroy
    if @school.user.present?
      if @school.user.has_role?(:headmaster)
        @school.user.roles = @school.user.roles-[:headmaster]
        @school.user.save
      end
    end
    @school.teachers.each do |teacher|
      if teacher.user.present?
        if teacher.user.has_role?(:teacher)
          teacher.user.roles = teacher.user.roles-[:teacher]
          teacher.user.save
        end
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
