  class QuestionPolicy

   attr_reader :user, :question
  def initialize(user, question)
    @user = user
    @question = question
  end

  def index?
    true
  end

  def show?
    scope.where(:id => question.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
     # binding.pry
    !@user.roles.blank? && (@user.roles.pluck(:role).include? "admin") ? true : @user.questions.include?(@question) || (
    !@user.roles.blank? && (@user.roles.pluck(:role).include? "moderator") && (@question.tag_list.include? "RoR") ? true : false ) if @user.present?
  end

  def edit?
    update?
  end

  def destroy?
    user.admin?
  end

  def scope
    Pundit.policy_scope!(user, question.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  private
    
     def user_status?
        return (!@user.roles.blank?)
     end

end

