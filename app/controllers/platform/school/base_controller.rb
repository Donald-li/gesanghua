class Platform::School::BaseController < ApplicationController
  before_action :login_require
  before_action :set_paper_trail_whodunnit
  helper_method :current_teacher
  layout 'platform_school'

  protected
  def user_for_paper_trail
    "老师：#{current_teacher.nickname}" if current_teacher
  end

  def info_for_paper_trail
    { ip: request.remote_ip }
  end

  def login_require
    return !! current_teacher
  end

  def current_teacher
    @current_teacher ||= current_user
  end

end
