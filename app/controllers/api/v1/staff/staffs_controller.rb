class Api::V1::Staff::StaffsController < Api::V1::BaseController

  def index
    @user = current_user
    if @user.has_role?(:project_manager) || @user.has_role?(:project_operator)
      api_success(data: {seach_result: @user.summary_builder, result: true})
    else
      api_success(data: {result: false}, message: '您没有权限！')
    end
  end

  def volunteer_list
    @user = current_user
    if @user.has_role?(:project_manager) || @user.has_role?(:project_operator)
      search = Volunteer.pass.search(params[:q])
      @volunteers = search.result.sorted.page(params[:page])
      api_success(data: {seach_result: @volunteers.map {|v| v.summary_builder }, result: true, pagination: json_pagination(@volunteers)})
    else
      api_success(data: {result: false}, message: '您没有权限！')
    end
  end

end
