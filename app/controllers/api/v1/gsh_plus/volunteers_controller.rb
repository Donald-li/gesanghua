class Api::V1::GshPlus::VolunteersController < Api::V1::BaseController
  def majors
    majors = Major.sorted
    api_success(data: majors.map{|m| m.summary_builder})
  end

  def volunteer_apply
    if current_user.volunteer.present? && current_user.volunteer.reject?
      api_success(data: {volunteer: current_user.volunteer.apply_builder, image: current_user.volunteer.try(:image).try(:summary_builder)})
    else
      api_success(data: '')
    end
  end

  def volunteer_info
    api_success(data: current_user.volunteer.summary_builder)
  end

  def create
    user = current_user
    if Volunteer.find_by(phone: params[:volunteer][:phone])
      return api_error(message: '该手机号已注册志愿者，请绑定手机号关联角色')
    end
    volunteer = user.volunteer || user.build_volunteer
    volunteer.attributes = {describe: params[:volunteer][:describe], phone: params[:volunteer][:phone]}
    user.attributes = {name: params[:volunteer][:name], id_card: params[:volunteer][:id_card]}
    unless user.save
      return api_error(message: user.errors.full_messages[0])
    end
    if volunteer.save
      volunteer.submit!
      volunteer.attach_image(params[:image_ids][0]) if params[:image_ids].present?
      volunteer.major_ids = params[:volunteer][:major_ids]
      api_success(data: true)
    else
      api_error(message: '申请失败，请重试')
    end
  end

  def edit_volunteer
    api_success(data: current_user.volunteer.detail_builder)
  end

  def update_volunteer
    volunteer = current_user.volunteer
    user = current_user
    volunteer.attributes = {workstation: params[:volunteer][:workstation], describe: params[:volunteer][:describe], phone: params[:volunteer][:phone]}
    user.attributes = {name: params[:volunteer][:user_name], email: params[:volunteer][:user_email], qq: params[:volunteer][:user_qq]}
    if user.save && volunteer.save
      user.attach_avatar(params[:image_id])
      api_success(message: '修改成功')
    else
      api_error(message: '修改失败，请重试')
    end
  end

  def vacation
    volunteer = current_user.volunteer
    if volunteer.update(leave_reason: {type: params[:type][0], content: params[:content]}, job_state: 'leave')
      api_success(message: '请假成功')
    else
      api_error(message: '请假失败')
    end
  end

  def cancel_vacation
    volunteer = current_user.volunteer
    if volunteer.update(leave_reason: {type: '', content: ''}, job_state: 'available')
      api_success(message: '销假成功')
    else
      api_error(message: '销假失败')
    end
  end

  def duration
    volunteer = current_user.volunteer
    task_volunteers = volunteer.task_volunteers.done.sorted
    api_success(data: {records: task_volunteers.map{|m| m.summary_builder}, total: volunteer.duration})
  end

end
