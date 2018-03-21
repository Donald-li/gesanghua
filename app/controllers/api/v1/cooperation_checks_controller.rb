class Api::V1::CooperationChecksController < Api::V1::BaseController

  def index
    api_success(data: current_user.roles)
  end

  def identity_user_info
    @user = current_user
    if params[:check_role] === 'teacher'
      if Teacher.find_by(phone: params[:phone]).present?
        @teacher = Teacher.find_by(phone: params[:phone])
        @teacher.update(user_id: current_user.id)
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
      else
        api_success(data: false, message: '验证失败，请重试')
      end
    elsif params[:check_role] === 'headmaster'
      @school = School.find_by(contact_phone: params[:phone])
      if @school.present?
        @school.update(user_id: @user.id)
        if @user.teacher.present?
          @teacher = @user.teacher
        else
          @teacher = @school.teachers.create(name: @school.contact_name, phone: @school.contact_phone, kind: 'headmaster', user: @user)
          @user.roles = @user.roles.push(:headmaster)
          @user.save
        end
        api_success(data: @teacher.identity_teacher_summary_builder)
      else
        api_success(data: false, message: '验证失败，请重试')
      end
    elsif params[:check_role] === 'county_user'
      if CountyUser.find_by(phone: params[:phone]).present?
        @county_user = CountyUser.find_by(phone: params[:phone])
        @county_user.update(user_id: current_user.id)
        if !@user.has_role?(:county_user)
          @user.roles = @user.roles.push(:county_user)
          @user.save
        end
        api_success(data: @county_user.summary_builder)
      else
        api_success(data: false, message: '验证失败，请重试')
      end
    elsif params[:check_role] === 'gsh_child'
      if GshChild.find_by(phone: params[:phone]).present?
        @gsh_child = GshChild.find_by(phone: params[:phone])
        @gsh_child.update(user_id: current_user.id)
        if !@user.has_role?(:gsh_child)
          @user.roles = @user.roles.push(:gsh_child)
          @user.save
        end
        api_success(data: @gsh_child.check_gsh_child_builder)
      else
        api_success(data: false, message: '验证失败，请重试')
      end
    elsif params[:check_role] === 'volunteer'
      @volunteer = Volunteer.find_by(phone: params[:phone])
      if @volunteer.present?
        if @volunteer.update(user: current_user, kind: 'activated')
          if !@user.has_role?(:volunteer)
            @user.roles = @user.roles.push(:volunteer)
            @user.save
          end
          api_success(data: @volunteer.check_builder)
        else
          api_success(data: false, message: '验证失败，请重试')
        end
      else
        api_success(data: false, message: "没有找到#{params[:phone]}关联的志愿者")
      end
    end
  end

end
