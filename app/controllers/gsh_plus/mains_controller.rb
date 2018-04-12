class GshPlus::MainsController < GshPlus::BaseController

  layout 'gsh_plus'
  def show
    @wechat_code_url = URI::encode "#{Settings.m_root_url}"
    if current_user.headmaster?
      @school = current_user.school
    elsif current_user.teacher?
      @school = current_user.teacher.school
    elsif current_user.create_school.present?
      @school = current_user.create_school
    end
    if current_user.volunteer?
      @volunteer = current_user.volunteer
    end
  end
end
