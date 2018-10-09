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

    # 管理后台项目功能
    can :manage_project, User, Project do |user, project|
      def check(user, project)
        return true if user.has_role?([:superadmin, :admin, :project_manager, :project_operator, :custom_service, :financial_staff])
        return project.id.in?(user.project_ids) if project
        true
      end
      check(user, project)
    end

    #指定代捐管理人
    can :manager_manager, User do |user|
      user.has_role?([:superadmin, :admin, :project_manager, :custom_service])
    end

    #团队移交
    can :manager_team_manager, User do |user|
      user.has_role?([:superadmin, :admin])
    end

    #运营管理-学校管理
    can :manager_school_manage, User do |user|
      user.has_role?([:superadmin, :admin, :project_manager])
    end

    #运营管理-用户身份
    can :manager_user_identity, User do |user|
      user.has_role?([:superadmin, :admin, :project_manager, :platform_manager])
    end

    #运营管理-团队管理
    can :manager_team_manage, User do |user|
      user.has_role?([:superadmin, :admin, :project_manager, :platform_manager])
    end

    #运营管理-志愿者管理
    can :manager_volunteer_manage, User do |user|
      user.has_role?([:superadmin, :admin, :project_manager, :platform_manager, :manpower_operator])
    end

    #运营管理-活动管理
    can :manager_campaign_manage, User do |user|
      user.has_role?([:superadmin, :admin, :project_manager])
    end
    #运营管理-平台管理
    can :manager_platform_manage, User do |user|
      user.has_role?([:superadmin, :admin, :platform_manager])
    end

    can :finance_pair_manage, User do |user|
      user.has_role?([:superadmin, :admin, :custom_service, :financial_staff]) || (user.has_role?([:project_manager]) && user.project_ids.include?(Project.pair_project.id))
    end

    can :header_admin_operation, User do |user|
      user.has_role?([:superadmin, :admin, :project_manager, :platform_manager, :manpower_operator, :custom_service, :financial_staff])
    end

    can :header_admin_project, User do |user|
      user.has_role?([:superadmin, :admin, :project_manager, :project_operator, :custom_service, :financial_staff])
    end

    can :header_admin_system, User do |user|
      user.has_role?([:superadmin, :admin, :project_manager, :manpower_operator])
    end

    can :header_admin_statistic, User do |user|
      user.has_role?([:superadmin, :admin, :project_manager, :financial_staff])
    end

    can :manager_finance_setting, User do |user|
      user.has_role?([:superadmin, :admin, :financial_staff])
    end

    can :header_admin_finance, User do |user|
      user.has_role?([:superadmin, :admin, :project_manager, :custom_service, :financial_staff])
    end
  end

end
