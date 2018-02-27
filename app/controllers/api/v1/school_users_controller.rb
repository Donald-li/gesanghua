class Api::V1::SchoolUsersController < Api::V1::BaseController

  def index
    @user = User.find_by(auth_token: params[:auth_token])
    if @user.school.present?
      @school = @user.school
      api_success(data: @school.summary_builder)
    else
      api_success(data: [])
    end
  end

  def show
    @user = User.find_by(auth_token: params[:auth_token])
    if @user.school.present?
      @school = @user.school
      api_success(data: @school.detail_builder)
    else
      api_success(data: [])
    end
  end

end
