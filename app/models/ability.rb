class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :view_private_details_of, user
    can :edit_goals_and_background, user
    if user.instructor?
      can :act_as_student, User
      unless user.viewing_as_student?
        can :manage, :all
        cannot :edit_goals_and_background, user
      end
    end
    can :create, Enrollment
    can :edit, user
    can :view, Assignment, course_id: user.course_ids, published: true
    can :view, Milestone
    can :view, Quiz, course_id: user.course_ids

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
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
