class Platform::School::TeacherProfilesController < Platform::School::BaseController
  layout 'platform_school_blank'
  before_action :set_user

  def edit
  end

  def update
    telephone = params[:phone_head] + params[:phone_body]
    if @user.update(name: params[:name]) && @user.teacher.school.update(contact_telephone: telephone)
      redirect_to edit_platform_school_teacher_profile_path, notice: '保存成功'
    else
      redirect_to edit_platform_school_teacher_profile_path, notice: '保存失败，请重试'
    end
  end

  private

  def set_user
    @user = current_user
  end

end
