class QuestionsController < ApplicationController
   
  before_filter :user_only, :except => [:show, :index]
  
  def index
    @page = params[:page]
     params[:tag] ? @questions = Question.tagged_with(params[:tag]).page(@page) : @questions = Question.where(:is_active => true).page(@page)

  end

  def show
    @page = params[:page]
    @question = Question.includes(:answers).find(params[:id])
    @question.view_count +=1 
    @question.save  
    @ans_pages = @question.answers
    @paginatable_array = Kaminari.paginate_array(@ans_pages).page(params[:page]).per(10)
  end

  def new 
    @question = Question.new
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
    answer = Answer.includes(:question).new(answer_params)
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
    
    if VoteCounter.where(user_id: params[:id_user], answer_id: params[:id], action: params[:vote_action]).present?
      act = "performed"
    else
     VoteCounter.create(user_id: params[:id_user], answer_id: params[:id], action: params[:vote_action])

      case params[:vote_action]
        when "increment"
         @answer.vote += 1
        when "decrement"
        @answer.vote -= 1
      end
    end
    @answer.save
    @vote_count = @answer.vote
    if act.present?
      @act= act
    else
     render partial: "vote_count" 
   end
  end
  

  def edit
     @question = Question.find(params[:id])
     # @question = Question.find(params[:question])
     # raise NotAuthorizedError unless QuestionPolicy.new(current_user, @question).edit?
     authorize @question, :edit?
  end

  def update
    @question = Question.find(params[:id])
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
    binding.pry
    redirect_to questions_path
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

  def vote_counter_params
    params.require(:vote_counter).permit(:user_id, :answer_id, :action)
  end

  def user_only
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end
end


