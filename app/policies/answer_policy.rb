  class AnswerPolicy

   attr_reader :user, :answer
  def initialize(user, answer)
    @user = user
    @answer = answer
  end

  def index?
    true
  end

  def show?
    scope.where(:id => answer.id).exists?
  end

  def create?
    false
  end

  def new?                        
    create?
  end

  def update?
      !@user.roles.blank? && (@user.roles.pluck(:role).include? "admin")  ? true : @user.answers.include?(@answer) || (
      !@user.roles.blank? && (@user.roles.pluck(:role).include? "moderator") && tags_check? ? true : false ) if @user.present?
  end

  def edit?
    update?
  end

  def destroy?
    user.admin?
  end

  def scope
    Pundit.policy_scope!(user, answer.class)
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

 def tags_check?
    @user.tag_list.each do  | u | 
     return @answer.question.tag_list.include?(u) ? true : false
    end
  end

end

