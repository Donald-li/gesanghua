class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud

    # superadmin admin
    # 超级管理员   管理员
    # project_manager project_operator camp_manager manpower_operator custom_service financial_staff  platform_manager
    # 项目管理员        项目操作员        探索营管理    人力管理            客服            财务             平台管理员
    # volunteer county_user gsh_child headmaster teacher
    # 志愿者     县团委       格桑花孩子  校长       老师
    # 管理超级用户功能
    can :manage_superadmin, User do |user|
      user.has_role?(:superadmin)
    end

    # 管理后台业务功能
    can :manage_operation, User do |user|
      user.has_role?([:superadmin, :admin])
    end

    # 导出功能
    can :manage_excel, User do |user|
      user.has_role?([:superadmin, :admin, :project_manager])
    end

  end
end
