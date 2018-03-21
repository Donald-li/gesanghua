class Api::V1::SchoolUsersController < Api::V1::BaseController

  def index
    @user = current_user
    @school = current_user.teacher.try(:school)
    if @school.present?
        api_success(data: {is_school_user: true, seach_result: @user.school_user_summary_builder})
    else
      api_success(data: {is_school_user: false}, message: '您不是学校用户')
    end
  end

  def show
    @school = current_user.teacher.try(:school)
    if @school.present?
        api_success(data: @school.detail_builder)
    else
      api_success(data: false, message: '您不是学校用户')
    end
  end

  def update_school
    province = params[:location][0]
    city = params[:location][1]
    district = params[:location][2]
    number = params[:number_list][0]['num']
    teacher_count = params[:number_list][1]['num']
    logistic_count = params[:number_list][2]['num']
    @school = School.find(params[:id])
    if @school.update(address: params[:address], province: province, city: city, district: district, postcode: params[:postcode], number: number, teacher_count: teacher_count, logistic_count: logistic_count, describe: params[:describe])
      @school.attach_logo(params[:logo][:id]) if params[:logo].present?
      api_success(data: {is_school_user: true, result: true}, message: '学校信息修改成功')
    else
      api_success(data: {is_school_user: true, result: false}, message: @school.errors.full_messages.first)
    end
  end

  def get_school_teachers
    @school = current_user.teacher.try(:school)
    if @school.present?
      @teachers = @school.teachers.teacher.sorted
      api_success(data: {is_school_user: true, seach_result: @teachers.map{|teacher| teacher.summary_builder}})
    else
      api_success(data: {is_school_user: false}, message: '您不是学校用户')
    end
  end

  def create_teacher
    @school = current_user.teacher.try(:school)
    if @school.present?
      name = params[:name]
      phone = params[:phone]
      id_card = params[:id_card]
      qq = params[:qq]
      openid = params[:openid]
      teacher_projects = params[:teacher_projects]
      @teacher = @school.teachers.new(name: name, phone: phone, id_card: id_card, qq: qq, openid: openid)
      # @teacher.new(name: name, phone: phone, id_card: id_card, qq: qq, openid: openid)
      if User.find_by(phone: params[:phone]).present?
        @user = User.find_by(phone: params[:phone])
        @teacher.user_id = @user.id
        @user.roles = @user.roles.push(:teacher)
        @user.save
      end
      if @teacher.save
        teacher_projects.each do |teacher_project|
          TeacherProject.create(project_id: teacher_project, teacher: @teacher)
        end
        api_success(data: {is_school_user: true, result: true}, message: '新建教师信息成功')
      else
        api_success(data: {is_school_user: true, result: false}, message: @teacher.errors.full_messages.first)
      end
    else
      api_success(data: {is_school_user: false}, message: '您不是学校用户')
    end
  end

  def get_teacher
    @teacher = Teacher.find(params[:id])
    api_success(data: @teacher.detail_builder)
  end

  def get_projects
    @projects = Project.all.sorted
    api_success(data: @projects.map{|project| project.teacher_project_summary_builder})
  end

  def update_teacher
    @school = current_user.teacher.try(:school)
    if @school.present?
      name = params[:name]
      phone = params[:phone]
      id_card = params[:id_card]
      qq = params[:qq]
      openid = params[:openid]
      teacher_projects = params[:teacher_projects]
      @teacher = Teacher.find(params[:id])
      if @teacher.update(name: name, phone: phone, id_card: id_card, qq: qq, openid: openid)
        TeacherProject.where(teacher: @teacher).destroy_all
        teacher_projects.each do |teacher_project|
          TeacherProject.create(project_id: teacher_project, teacher: @teacher)
        end
        api_success(data: {is_school_user: true, result: true}, message: '修改教师信息成功')
      else
        api_success(data: {is_school_user: true, result: false}, message: @teacher.errors.full_messages.first)
      end
    else
      api_success(data: {is_school_user: false}, message: '您不是学校用户')
    end
  end

  def delete_teacher
    @school = current_user.teacher.try(:school)
    if @school.present?
      @teacher = @school.teachers.find(params[:id])
      if @teacher.destroy
        api_success(data: {is_school_user: true, result: true}, message: '删除教师信息成功')
      else
        api_success(data: {is_school_user: true, result: false}, message: @teacher.errors.full_messages.first)
      end
    else
      api_success(data: {is_school_user: false}, message: '您不是学校用户')
    end
  end

  def get_school_user
    @user = current_user
    @school = current_user.teacher.try(:school)
    if @school.present?
      api_success(data: {is_school_user: true, seach_result: @user.school_user_summary_builder})
    else
      api_success(data: {is_school_user: false}, message: '您不是学校用户')
    end
  end

  def update_school_user
    @school = current_user.teacher.try(:school)
    if @school.present?
      if current_user.update(name: params[:user_name], nickname: params[:user_nickname])
        current_user.attach_avatar(params[:avatar][:id]) if params[:avatar].present?
        @school.update(contact_telephone: params[:contact_telephone]) if params[:contact_telephone].present?
        api_success(data: {is_school_user: true, result: true}, message: '用户信息修改成功')
      else
        api_success(data: {is_school_user: true, result: false}, message: @school.errors.full_messages.first)
      end
    else
      api_success(data: {is_school_user: false}, message: '您不是学校用户')
    end
  end

end
