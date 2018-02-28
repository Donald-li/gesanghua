class Api::V1::GshPlus::SchoolsController < Api::V1::BaseController

  def create
    school = School.find_by(contact_phone: school_params[:contact_phone], contact_idcard: school_params[:contact_idcard])
    if school.present?
      if school.update(school_params.except(:location, :number_list).merge(province: school_params[:location][0], city: school_params[:location][1], district: school_params[:location][2], number: params[:item_list][0][:num], teacher_count: params[:item_list][1][:num], logistic_count: params[:item_list][2][:num]))
        api_success(message: '申请修改并提交成功', data: true)
      else
        api_success(message: '申请失败，请重试', data: false)
      end
    else
      school = School.new(school_params.except(:location, :number_list).merge(province: school_params[:location][0], city: school_params[:location][1], district: school_params[:location][2], number: params[:item_list][0][:num], teacher_count: params[:item_list][1][:num], logistic_count: params[:item_list][2][:num], user: current_user))
      if school.save
        school.attach_card_image(params[:card_image].first[:id].to_i) if params[:card_image].present?
        school.attach_certificate_image(params[:certificate_image].first[:id].to_i) if params[:certificate_image].present?
        api_success(message: '申请成功', data: true)
      else
        api_success(message: '申请失败，请重试', data: false)
      end
    end
  end

  private
  def school_params
    params.require(:school).permit!
  end

end
