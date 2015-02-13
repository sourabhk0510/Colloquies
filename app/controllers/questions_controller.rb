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

  def edit
     @question = Question.find(params[:id])
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

  def add_answer
    @question = Question.find(params[:question_id])
    answer = Answer.new(answer_params)
    answer.user_id = current_user.id
    answer.vote = 0
    answer.save
    @question.answers << answer
    respond_to do |format|
      format.js
    end
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
        @answer.vote += 1
      when "decrement"
       @answer.vote -= 1
    end
    @answer.save
    @vote_count = @answer.vote
    render partial: "vote_count"
  end

  def destroy
    @question = Question.find(params[:id])
    @question.is_active = false
    @question.save
    @questions = params[:tag] ? @questions = Question.tagged_with(params[:tag]) : @questions = Question.where(:is_active => true)
    render partial: "q_index"
  end
  
  
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