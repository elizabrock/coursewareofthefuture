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
      cannot :instructify, user
      cannot :observify, user
    end
    can :edit, user
    can :view, Assignment, course_id: user.course_ids, published: true
    can :view, Milestone
    can :view, Quiz, course_id: user.course_ids

    # See the cancan wiki for details on how to define abilities:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
