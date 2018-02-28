class Api::V1::SchoolUsersController < Api::V1::BaseController

  def index
    @user = current_user
    if @user.school.present?
      @school = @user.school
      api_success(data: @school.summary_builder)
    else
      api_success(data: [], message: '您不是学校用户！')
    end
  end

  def show
    @user = current_user
    if @user.school.present?
      @school = @user.school
      api_success(data: @school.detail_builder)
    else
      api_success(data: [], message: '您不是学校用户！')
    end
  end

  def update_school
    @user = current_user
    @school = @user.school if @user.present?
    if @school.present?
      province = params[:location][0]
      city = params[:location][1]
      district = params[:location][2]
      number = params[:number_list][0]['num']
      teacher_count = params[:number_list][1]['num']
      logistic_count = params[:number_list][2]['num']
      @school = School.find(params[:id])
      if @school.update(address: params[:address], province: province, city: city, district: district, postcode: params[:postcode], number: number, teacher_count: teacher_count, logistic_count: logistic_count, describe: params[:describe])
        @school.attach_logo(params[:logo][:id]) if params[:logo].present?
        api_success(data: {is_school_user: true, result: true}, message: '学校信息修改成功！')
      else
        api_success(data: {is_school_user: true, result: false}, message: '学校信息修改失败，请重试！')
      end
    else
      api_success(data: {is_school_user: false}, message: '您不是学校用户！')
    end
  end

  def get_school_teachers
    @user = current_user
    @school = @user.school if @user.present?
    @teachers = @school.teachers
    api_success(data: @teachers.map{|teacher| teacher.summary_builder})
  end

  def create_teacher
    @user = current_user
    @school = @user.school if @user.present?
    if @school.present?
      name = params[:name]
      phone = params[:phone]
      idcard = params[:idcard]
      qq = params[:qq]
      openid = params[:openid]
      teacher_projects = params[:teacher_projects]
      @teacher = @school.teachers.new(name: name, phone: phone, idcard: idcard, qq: qq, openid: openid)
      # @teacher.new(name: name, phone: phone, idcard: idcard, qq: qq, openid: openid)
      if @teacher.save
        teacher_projects.each do |teacher_project|
          TeacherProject.create(project_id: teacher_project, teacher: @teacher)
        end
        api_success(data: {is_school_user: true, result: true}, message: '新建教师信息成功。')
      else
        api_success(data: {is_school_user: true, result: false}, message: '新建教师信息失败，请重试！')
      end
    else
      api_success(data: {is_school_user: false}, message: '您不是学校用户！')
    end
  end

  def get_teacher
    @teacher = Teacher.find(params[:id])
    api_success(data: @teacher.detail_builder)
  end

  def get_projects
    @projects = Project.all
    api_success(data: @projects.map{|project| project.teacher_project_summary_builder})
  end

  def update_teacher
    @user = current_user
    @school = @user.school if @user.present?
    if @school.present?
      name = params[:name]
      phone = params[:phone]
      idcard = params[:idcard]
      qq = params[:qq]
      openid = params[:openid]
      teacher_projects = params[:teacher_projects]
      @teacher = Teacher.find(params[:id])
      if @teacher.update(name: name, phone: phone, idcard: idcard, qq: qq, openid: openid)
        TeacherProject.where(teacher: @teacher).destroy_all
        teacher_projects.each do |teacher_project|
          TeacherProject.create(project_id: teacher_project, teacher: @teacher)
        end
        api_success(data: {is_school_user: true, result: true}, message: '修改教师信息成功。')
      else
        api_success(data: {is_school_user: true, result: false}, message: '修改教师信息失败，请重试！')
      end
    else
      api_success(data: {is_school_user: false}, message: '您不是学校用户！')
    end
  end

  def delete_teacher
    @user = current_user
    @school = @user.school if @user.present?
    if @school.present?
      @teacher = @school.teachers.find(params[:id])
      if @teacher.destroy
        api_success(data: {is_school_user: true, result: true}, message: '删除教师信息成功。')
      else
        api_success(data: {is_school_user: true, result: false}, message: '删除教师信息失败，请重试！')
      end
    else
      api_success(data: {is_school_user: false}, message: '您不是学校用户！')
    end
  end
end
