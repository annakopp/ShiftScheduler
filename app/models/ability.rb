class Ability
  include CanCan::Ability


  def initialize(user)

    alias_action :create, :read, :update, :destroy, :to => :crud

    if user.user_type == "admin"
      can :manage, User, manager_id: user.id
      can :add_employees, User
      can :crud, Shift, manager_id: user.id
    else
      can :read, User, id: user.id
      can :edit, User, id: user.id

      can :read, Shift, id: user.id
    end

  end
end
