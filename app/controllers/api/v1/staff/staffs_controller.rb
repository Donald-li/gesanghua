class Api::V1::Staff::StaffsController < Api::V1::BaseController

  def index
    @user = current_user
    if @user.has_role?(:project_manager) || @user.has_role?(:project_operator)
      api_success(data: {search_result: @user.summary_builder, result: true})
    else
      api_success(data: {result: false}, message: '您没有权限！')
    end
  end

  def volunteer_list
    @user = current_user
    if @user.has_role?(:project_manager) || @user.has_role?(:project_operator)
      search = Volunteer.pass.search(params[:q])
      @volunteers = search.result.sorted.page(params[:page])
      api_success(data: {search_result: @volunteers.map {|v| v.summary_builder }, result: true, pagination: json_pagination(@volunteers)})
    else
      api_success(data: {result: false}, message: '您没有权限！')
    end
  end

  def school_list
    @user = current_user
    if @user.has_role?(:project_manager) || @user.has_role?(:project_operator)
      search = School.pass.search(params[:q])
      @schools = search.result.sorted.page(params[:page])
      api_success(data: {search_result: @schools.map {|v| v.summary_builder }, result: true, pagination: json_pagination(@schools)})
    else
      api_success(data: {result: false}, message: '您没有权限！')
    end
  end

  def teacher_list
    @user = current_user
    if @user.has_role?(:project_manager) || @user.has_role?(:project_operator)
      @school = School.find(params[:school_id])
      @teachers = @school.teachers.show.sorted.page(params[:page])
      api_success(data: {search_result: @teachers.map {|v| v.detail_builder }, result: true, pagination: json_pagination(@teachers)})
    else
      api_success(data: {result: false}, message: '您没有权限！')
    end
  end

end
