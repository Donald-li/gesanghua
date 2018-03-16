class Api::V1::CooperationChecksController < Api::V1::BaseController

  def index
    api_success(data: current_user.roles)
  end

  def identity_user_info
    if Teacher.find_by(phone: params[:id]).present?
      @teacher = Teacher.find_by(phone: params[:id])
      @teacher.update(user_id: current_user.id)
      @user = current_user
      if @teacher.headmaster?
        if !@user.has_role?(:headmaster)
          @user.roles = @user.roles.push(:headmaster)
          @user.save
        end
      else
        if !@user.has_role?(:teacher)
          @user.roles = @user.roles.push(:teacher)
          @user.save
        end
      end
      api_success(data: @teacher.identity_teacher_summary_builder)
    end
  end

end
