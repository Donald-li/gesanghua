class Api::V1::GshPlus::SchoolsController < Api::V1::BaseController

  def create
    school = School.find_by(contact_phone: school_params[:contact_phone], contact_id_card: school_params[:contact_id_card]) || School.find_by(user_id: current_user.id)
    if school.present?
      if school.update(school_params.except(:location).merge(province: school_params[:location][0], city: school_params[:location][1], district: school_params[:location][2]))
        school.submit!
        api_success(message: '申请修改并提交成功', data: true)
      else
        api_success(message: school.errors.full_messages.first, data: false)
      end
    else
      school = School.new(school_params.except(:location).merge(province: school_params[:location][0], city: school_params[:location][1], district: school_params[:location][2], creater: current_user))
      if school.save
        school.attach_card_image(params[:card_image].first[:id].to_i) if params[:card_image].present?
        school.attach_certificate_image(params[:certificate_image].first[:id].to_i) if params[:certificate_image].present?
        api_success(message: '申请成功', data: true)
      else
        api_success(message: school.errors.full_messages.first, data: false)
      end
    end
  end

  def show
    @school = current_user.teacher.try(:school) || current_user.create_school
    if @school.present?
      api_success(data: @school.detail_builder)
    else
      api_success(data: false, message: '您不是学校用户！')
    end
  end

  private
  def school_params
    params.require(:school).permit!
  end

end
