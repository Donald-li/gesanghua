class Api::V1::CooperationChecksController < Api::V1::BaseController

  def index
    api_success(data: current_user.roles)
  end

  def identity_user_info
    if params[:check_role] === 'teacher' || params[:check_role] === 'headmaster'
      if Teacher.find_by(phone: params[:phone]).present?
        @teacher = Teacher.find_by(phone: params[:phone])
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
    elsif params[:check_role] === 'county_user'
      if CountyUser.find_by(phone: params[:phone]).present?
        @county_user = CountyUser.find_by(phone: params[:phone])
        @county_user.update(user_id: current_user.id)
        @user = current_user
        if !@user.has_role?(:county_user)
          @user.roles = @user.roles.push(:county_user)
          @user.save
        end
        api_success(data: @county_user.summary_builder)
      end
    elsif params[:check_role] === 'gsh_child'
      if GshChild.find_by(phone: params[:phone]).present?
        @gsh_child = GshChild.find_by(phone: params[:phone])
        @gsh_child.update(user_id: current_user.id)
        @user = current_user
        if !@user.has_role?(:gsh_child)
          @user.roles = @user.roles.push(:gsh_child)
          @user.save
        end
        api_success(data: @gsh_child.check_gsh_child_builder)
      end
    end
  end

end
