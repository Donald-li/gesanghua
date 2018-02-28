class Api::V1::SchoolUsersController < Api::V1::BaseController

  def index
    @user = User.find_by(auth_token: params[:auth_token])
    if @user.school.present?
      @school = @user.school
      api_success(data: @school.summary_builder)
    else
      api_success(data: [], message: '您不是学校用户！')
    end
  end

  def show
    @user = User.find_by(auth_token: params[:auth_token])
    if @user.school.present?
      @school = @user.school
      api_success(data: @school.detail_builder)
    else
      api_success(data: [], message: '您不是学校用户！')
    end
  end

  def update_school
    @user = User.find_by(auth_token: params[:auth_token])
    @school = @user.school if @user.present?
    if @school.present?
      province = params[:district][0]
      city = params[:district][1]
      district = params[:district][2]
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

end
