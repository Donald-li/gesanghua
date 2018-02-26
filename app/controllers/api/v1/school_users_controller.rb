class Api::V1::SchoolUsersController < Api::V1::BaseController

  def show
    # @user = User.find(params[:id]) if params[:id].present?
    # if @user.school.present?
    #   @school = @user.school
    #   api_success(data: @school.summary_builder)
    # end
    @school = School.find(2)
    api_success(data: @school.detail_builder)
  end

  def school_details
    @school = School.find(2)
    api_success(data: @school.detail_builder)
  end

end
