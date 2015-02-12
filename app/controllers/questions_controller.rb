class QuestionsController < ApplicationController
   
  before_filter :user_only, :except => [:show, :index]
  
  def index
    params[:tag] ? @questions = Question.tagged_with(params[:tag]) : @questions = Question.where(:is_active => true)
  end

  def show
    @question = Question.find(params[:id])
    @question.view_count +=1 
    @question.save  
  end

  def new 
    @question = Question.new
    render partial: "new"
  end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to questions_path
     else
      render('new')
    end
  end

  def add_answer
    @question = Question.find(params[:question_id])
    answer = Answer.new(answer_params)
    answer.user_id = current_user.id
    answer.vote = 0
    answer.save
    @question.answers << answer
    #@answer = @question.answers.build
    redirect_to question_path(@question)
  end


  def user_question 
    @questions = current_user.questions
    @user = current_user.name
  end

   
  def user_answer
    @answer = current_user.answers.includes(:question)
    @user = current_user.name
  end

  def update_vote
    @answer= Answer.find(params[:id])
  
    case params[:vote_action]

      when "increment"
       # @answer= Answer.find(params[:ans_id_up])
        @answer.vote += 1
      when "decrement"
       # @answer= Answer.find(params[:ans_id_down])
       @answer.vote -= 1
     end
    @answer.save
    #  # @answer_down = Answer.find(params[:ans_id_down])
    #  # @answer_down.vote -= 1
    # @answer_down.save
    @vote_count = @answer.vote
    render partial: "vote_count"
  end
  

  def edit
     @question = Question.find(params[:id])
     # @question = Question.find(params[:question])
     # raise NotAuthorizedError unless QuestionPolicy.new(current_user, @question).edit?
     authorize @question, :edit?
  end

  def update
    # @question = Question.find(params[:id])
    # if @question.update_attributes(question_params)
    #   redirect_to question_path(@question.id)
    # else
    #   render('edit')
    # end
    @question = Question.find(params[:id])
    # authorize @question
   if @question.update(question_params)
    redirect_to @question
   else
    render :edit
  end
  end
   

  
  def destroy
    @question = Question.find(params[:id])
    @question.is_active = false
    @question.save
    # binding.pry
    @questions = params[:tag] ? @questions = Question.tagged_with(params[:tag]) : @questions = Question.where(:is_active => true)
    render partial: "q_index"
  end

  # def find_user
    #  @user = User.find(params[:user_id]) if params[:user_id]
  # end
  
  private

  def question_params
    params.require(:question).permit(:user_id, :title, :description, :tag_list)
  end

  def answer_params
    params.require(:answer).permit(:feedback)
  end

  def user_only
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end
end


