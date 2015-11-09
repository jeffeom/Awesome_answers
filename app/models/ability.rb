class Ability
  include CanCan::Ability

  def initialize(user)
    # user here is essentially current_user and it may be nil
    # we set it to User.new if it's nil:
    user ||= User.new

    # We define an ability in here that states that only the user who created
    # a question is able to 'manage' the question. :manage here includes any
    # operation such as: destroy, edit, delete, approve...ect
    can :manage, Question do |q|
      user == q.user
    end
    # byebug
    can :manage, Answer do |a|
      user == a.user
    end

    can :destroy, Answer do |a|
      user == a.question.user
    end

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
