class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud

    # 管理超级用户功能
    can :manage_superadmin, User do |user|
      user.has_role?(:superadmin)
    end

    # 管理后台业务功能
    can :manage_operation, User do |user|
      user.has_role?([:superadmin, :admin])
    end

    # 管理后台财务功能
    can :manage_financial, User do |user|
      user.has_role?([:superadmin, :financial_staff])
    end

    # 管理后台客服(用户管理)功能
    can :manage_custom_service, User do |user|
      user.has_role?([:superadmin, :admin, :financial_staff, :custom_service])
    end

    # 管理后台项目功能
    can :manage_project, User, Project do |user, project|
      def check(user, project)
        return true if user.has_role?([:superadmin, :admin])
        return false unless user.has_role?(:project_manager)
        return project.id.in?(user.project_ids) if project
        true
      end
      check(user, project)
    end

    # 操作后台项目功能
    can :operate_project, User, Project do |user, project|
      def check(user, project)
        return true if user.has_role?([:superadmin, :admin])
        return false unless user.has_role?([:project_manager, :project_operator])
        return project.id.in?(user.project_ids) if project
        true
      end
      check(user, project)
    end


    # if !user
    #   can :update, :all
    # end
    # can :manage, :all if user.has_role? :admin
    # can :crud, Project, user_id: user.id
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
